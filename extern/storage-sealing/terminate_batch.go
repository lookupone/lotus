package sealing

import (
	"bytes"
	"context"
	"sort"
	"sync"
	"time"

	"github.com/ipfs/go-cid"
	"golang.org/x/xerrors"

	"github.com/filecoin-project/go-address"
	"github.com/filecoin-project/go-bitfield"
	"github.com/filecoin-project/go-state-types/abi"
	"github.com/filecoin-project/go-state-types/big"
	"github.com/filecoin-project/go-state-types/dline"
	miner2 "github.com/filecoin-project/specs-actors/v2/actors/builtin/miner"

	"github.com/filecoin-project/lotus/api"
	"github.com/filecoin-project/lotus/chain/actors/builtin/miner"
)

var (
	// TODO: config

	TerminateBatchMax  uint64 = 100 // adjust based on real-world gas numbers, actors limit at 10k
	TerminateBatchMin  uint64 = 1
	TerminateBatchWait        = 5 * time.Minute
)

type TerminateBatcherApi interface {
	StateSectorPartition(ctx context.Context, maddr address.Address, sectorNumber abi.SectorNumber, tok TipSetToken) (*SectorLocation, error)
	SendMsg(ctx context.Context, from, to address.Address, method abi.MethodNum, value, maxFee abi.TokenAmount, params []byte) (cid.Cid, error)
	StateMinerInfo(context.Context, address.Address, TipSetToken) (miner.MinerInfo, error)
	StateMinerProvingDeadline(context.Context, address.Address, TipSetToken) (*dline.Info, error)
}

type TerminateBatcher struct {
	api     TerminateBatcherApi
	maddr   address.Address
	mctx    context.Context
	addrSel AddrSel
	feeCfg  FeeConfig

	todo map[SectorLocation]*bitfield.BitField // MinerSectorLocation -> BitField

	waiting map[SectorLocation][]chan cid.Cid

	notify, stop, stopped chan struct{}
	force                 chan chan *cid.Cid
	lk                    sync.Mutex
}

func NewTerminationBatcher(mctx context.Context, maddr address.Address, api TerminateBatcherApi, addrSel AddrSel, feeCfg FeeConfig) *TerminateBatcher {
	b := &TerminateBatcher{
		api:     api,
		maddr:   maddr,
		mctx:    mctx,
		addrSel: addrSel,
		feeCfg:  feeCfg,

		todo:    map[SectorLocation]*bitfield.BitField{},
		waiting: map[SectorLocation][]chan cid.Cid{},

		notify:  make(chan struct{}, 1),
		force:   make(chan chan *cid.Cid),
		stop:    make(chan struct{}),
		stopped: make(chan struct{}),
	}

	go b.run()

	return b
}

func (b *TerminateBatcher) run() {
	var forceRes chan *cid.Cid
	var lastMsg *cid.Cid

	for {
		if forceRes != nil {
			forceRes <- lastMsg
			forceRes = nil
		}
		lastMsg = nil

		var notif, after bool
		select {
		case <-b.stop:
			close(b.stopped)
			return
		case <-b.notify:
			notif = true // send above max
		case <-time.After(TerminateBatchWait):
			after = true // send above min
		case fr := <-b.force: // user triggered
			forceRes = fr
		}

		var err error
		lastMsg, err = b.processBatch(notif, after)
		if err != nil {
			log.Warnw("TerminateBatcher processBatch error", "error", err)
		}
	}
}

func (b *TerminateBatcher) processBatch(notif, after bool) (*cid.Cid, error) {
	dl, err := b.api.StateMinerProvingDeadline(b.mctx, b.maddr, nil)
	if err != nil {
		return nil, xerrors.Errorf("getting proving deadline info failed: %w", err)
	}

	b.lk.Lock()
	defer b.lk.Unlock()
	params := miner2.TerminateSectorsParams{}

	var total uint64
	for loc, sectors := range b.todo {
		n, err := sectors.Count()
		if err != nil {
			log.Errorw("TerminateBatcher: failed to count sectors to terminate", "deadline", loc.Deadline, "partition", loc.Partition, "error", err)
			continue
		}

		// don't send terminations for currently challenged sectors
		if loc.Deadline == (dl.Index+1)%miner.WPoStPeriodDeadlines || // not in next (in case the terminate message takes a while to get on chain)
			loc.Deadline == dl.Index || // not in current
			(loc.Deadline+1)%miner.WPoStPeriodDeadlines == dl.Index { // not in previous
			continue
		}

		if n < 1 {
			log.Warnw("TerminateBatcher: zero sectors in bucket", "deadline", loc.Deadline, "partition", loc.Partition)
			continue
		}

		toTerminate, err := sectors.Copy()
		if err != nil {
			log.Warnw("TerminateBatcher: copy sectors bitfield", "deadline", loc.Deadline, "partition", loc.Partition, "error", err)
			continue
		}

		if total+n > uint64(miner.DeclarationsMax) {
			n = uint64(miner.DeclarationsMax) - total

			toTerminate, err = toTerminate.Slice(0, n)
			if err != nil {
				log.Warnw("TerminateBatcher: slice toTerminate bitfield", "deadline", loc.Deadline, "partition", loc.Partition, "error", err)
				continue
			}

			*sectors, err = bitfield.SubtractBitField(*sectors, toTerminate)
			if err != nil {
				log.Warnw("TerminateBatcher: sectors-toTerminate", "deadline", loc.Deadline, "partition", loc.Partition, "error", err)
				continue
			}
		}

		total += n

		params.Terminations = append(params.Terminations, miner2.TerminationDeclaration{
			Deadline:  loc.Deadline,
			Partition: loc.Partition,
			Sectors:   toTerminate,
		})

		if total >= uint64(miner.DeclarationsMax) {
			break
		}
	}

	if len(params.Terminations) == 0 {
		return nil, nil // nothing to do
	}

	if notif && total < TerminateBatchMax {
		return nil, nil
	}

	if after && total < TerminateBatchMin {
		return nil, nil
	}

	enc := new(bytes.Buffer)
	if err := params.MarshalCBOR(enc); err != nil {
		return nil, xerrors.Errorf("couldn't serialize TerminateSectors params: %w", err)
	}

	mi, err := b.api.StateMinerInfo(b.mctx, b.maddr, nil)
	if err != nil {
		return nil, xerrors.Errorf("couldn't get miner info: %w", err)
	}

	from, _, err := b.addrSel(b.mctx, mi, api.TerminateSectorsAddr, b.feeCfg.MaxTerminateGasFee, b.feeCfg.MaxTerminateGasFee)
	if err != nil {
		return nil, xerrors.Errorf("no good address found: %w", err)
	}

	mcid, err := b.api.SendMsg(b.mctx, from, b.maddr, miner.Methods.TerminateSectors, big.Zero(), b.feeCfg.MaxTerminateGasFee, enc.Bytes())
	if err != nil {
		return nil, xerrors.Errorf("sending message failed: %w", err)
	}
	log.Infow("Sent TerminateSectors message", "cid", mcid, "from", from, "terminations", len(params.Terminations))

	for _, t := range params.Terminations {
		delete(b.todo, SectorLocation{
			Deadline:  t.Deadline,
			Partition: t.Partition,
		})
	}

	for _, w := range b.waiting {
		for _, ch := range w {
			ch <- mcid // buffered
		}
	}

	b.waiting = map[SectorLocation][]chan cid.Cid{}

	return &mcid, nil
}

// register termination, wait for batch message, return message CID
func (b *TerminateBatcher) AddTermination(ctx context.Context, s abi.SectorID) (cid.Cid, error) {
	maddr, err := address.NewIDAddress(uint64(s.Miner))
	if err != nil {
		return cid.Undef, err
	}

	loc, err := b.api.StateSectorPartition(ctx, maddr, s.Number, nil)
	if err != nil {
		return cid.Undef, xerrors.Errorf("getting sector location: %w", err)
	}
	if loc == nil {
		return cid.Undef, xerrors.New("sector location not found")
	}

	b.lk.Lock()
	bf, ok := b.todo[*loc]
	if !ok {
		n := bitfield.New()
		bf = &n
		b.todo[*loc] = bf
	}
	bf.Set(uint64(s.Number))

	sent := make(chan cid.Cid, 1)
	b.waiting[*loc] = append(b.waiting[*loc], sent)

	select {
	case b.notify <- struct{}{}:
	default: // already have a pending notification, don't need more
	}
	b.lk.Unlock()

	select {
	case c := <-sent:
		return c, nil
	case <-ctx.Done():
		return cid.Undef, ctx.Err()
	}
}

func (b *TerminateBatcher) Flush(ctx context.Context) (*cid.Cid, error) {
	resCh := make(chan *cid.Cid, 1)
	select {
	case b.force <- resCh:
		select {
		case res := <-resCh:
			return res, nil
		case <-ctx.Done():
			return nil, ctx.Err()
		}
	case <-ctx.Done():
		return nil, ctx.Err()
	}
}

func (b *TerminateBatcher) Pending(ctx context.Context) ([]abi.SectorID, error) {
	b.lk.Lock()
	defer b.lk.Unlock()

	mid, err := address.IDFromAddress(b.maddr)
	if err != nil {
		return nil, err
	}

	res := make([]abi.SectorID, 0)
	for _, bf := range b.todo {
		err := bf.ForEach(func(id uint64) error {
			res = append(res, abi.SectorID{
				Miner:  abi.ActorID(mid),
				Number: abi.SectorNumber(id),
			})
			return nil
		})
		if err != nil {
			return nil, err
		}
	}

	sort.Slice(res, func(i, j int) bool {
		if res[i].Miner != res[j].Miner {
			return res[i].Miner < res[j].Miner
		}

		return res[i].Number < res[j].Number
	})

	return res, nil
}

func (b *TerminateBatcher) Stop(ctx context.Context) error {
	close(b.stop)

	select {
	case <-b.stopped:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

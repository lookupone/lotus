module github.com/filecoin-project/lotus

go 1.16

require (
	contrib.go.opencensus.io/exporter/jaeger v0.1.0
	contrib.go.opencensus.io/exporter/prometheus v0.1.0
	github.com/BurntSushi/toml v0.3.1
	github.com/GeertJohan/go.rice v1.0.0
	github.com/Gurpartap/async v0.0.0-20180927173644-4f7f499dd9ee
	github.com/Kubuxu/imtui v0.0.0-20210401140320-41663d68d0fa
	github.com/StackExchange/wmi v0.0.0-20190523213315-cbe66965904d // indirect
	github.com/acarl005/stripansi v0.0.0-20180116102854-5a71ef0e047d
	github.com/alecthomas/jsonschema v0.0.0-20200530073317-71f438968921
	github.com/buger/goterm v0.0.0-20200322175922-2f3e71b85129
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/cockroachdb/pebble v0.0.0-20201001221639-879f3bfeef07
	github.com/coreos/go-systemd/v22 v22.1.0
	github.com/detailyang/go-fallocate v0.0.0-20180908115635-432fa640bd2e
	github.com/dgraph-io/badger/v2 v2.2007.2
	github.com/docker/go-units v0.4.0
	github.com/drand/drand v1.2.1
	github.com/drand/kyber v1.1.4
	github.com/dustin/go-humanize v1.0.0
	github.com/elastic/go-sysinfo v1.3.0
	github.com/elastic/gosigar v0.12.0
	github.com/etclabscore/go-openrpc-reflect v0.0.36
	github.com/fatih/color v1.9.0
	github.com/filecoin-project/dagstore v0.4.3
	github.com/filecoin-project/filecoin-ffi v0.30.4-0.20200910194244-f640612a1a1f
	github.com/filecoin-project/go-address v0.0.5
	github.com/filecoin-project/go-bitfield v0.2.4
	github.com/filecoin-project/go-cbor-util v0.0.0-20191219014500-08c40a1e63a2
	github.com/filecoin-project/go-commp-utils v0.1.1-0.20210427191551-70bf140d31c7
	github.com/filecoin-project/go-crypto v0.0.0-20191218222705-effae4ea9f03
	github.com/filecoin-project/go-data-transfer v1.7.8
	github.com/filecoin-project/go-fil-commcid v0.1.0
	github.com/filecoin-project/go-fil-commp-hashhash v0.1.0
	github.com/filecoin-project/go-fil-markets v1.8.1
	github.com/filecoin-project/go-jsonrpc v0.1.4-0.20210217175800-45ea43ac2bec
	github.com/filecoin-project/go-multistore v0.0.3
	github.com/filecoin-project/go-padreader v0.0.0-20210723183308-812a16dc01b1
	github.com/filecoin-project/go-paramfetch v0.0.2-0.20210614165157-25a6c7769498
	github.com/filecoin-project/go-state-types v0.1.1-0.20210810190654-139e0e79e69e
	github.com/filecoin-project/go-statemachine v1.0.1
	github.com/filecoin-project/go-statestore v0.1.1
	github.com/filecoin-project/go-storedcounter v0.0.0-20200421200003-1c99c62e8a5b
	github.com/filecoin-project/specs-actors v0.9.14
	github.com/filecoin-project/specs-actors/v2 v2.3.5
	github.com/filecoin-project/specs-actors/v3 v3.1.1
	github.com/filecoin-project/specs-actors/v4 v4.0.1
	github.com/filecoin-project/specs-actors/v5 v5.0.4
	github.com/filecoin-project/specs-storage v0.1.1-0.20201105051918-5188d9774506
	github.com/filecoin-project/test-vectors/schema v0.0.5
	github.com/gbrlsnchs/jwt/v3 v3.0.0-beta.1
	github.com/gdamore/tcell/v2 v2.2.0
	github.com/go-kit/kit v0.10.0
	github.com/go-ole/go-ole v1.2.4 // indirect
	github.com/golang/mock v1.6.0
	github.com/google/uuid v1.2.0
	github.com/gorilla/mux v1.7.4
	github.com/gorilla/websocket v1.4.2
	github.com/hako/durafmt v0.0.0-20200710122514-c0fb7b4da026
	github.com/hannahhoward/go-pubsub v0.0.0-20200423002714-8d62886cc36e
	github.com/hashicorp/go-multierror v1.1.0
	github.com/hashicorp/golang-lru v0.5.4
	github.com/influxdata/influxdb1-client v0.0.0-20191209144304-8bf82d3c094d
	github.com/ipfs/bbloom v0.0.4
	github.com/ipfs/go-bitswap v0.3.4
	github.com/ipfs/go-block-format v0.0.3
	github.com/ipfs/go-blockservice v0.1.5
	github.com/ipfs/go-cid v0.1.0
	github.com/ipfs/go-cidutil v0.0.2
	github.com/ipfs/go-datastore v0.4.5
	github.com/ipfs/go-ds-badger2 v0.1.1-0.20200708190120-187fc06f714e
	github.com/ipfs/go-ds-leveldb v0.4.2
	github.com/ipfs/go-ds-measure v0.1.0
	github.com/ipfs/go-ds-pebble v0.0.2-0.20200921225637-ce220f8ac459
	github.com/ipfs/go-filestore v1.0.0
	github.com/ipfs/go-fs-lock v0.0.6
	github.com/ipfs/go-graphsync v0.6.9
	github.com/ipfs/go-ipfs-blockstore v1.0.4
	github.com/ipfs/go-ipfs-blocksutil v0.0.1
	github.com/ipfs/go-ipfs-chunker v0.0.5
	github.com/ipfs/go-ipfs-ds-help v1.0.0
	github.com/ipfs/go-ipfs-exchange-interface v0.0.1
	github.com/ipfs/go-ipfs-exchange-offline v0.0.1
	github.com/ipfs/go-ipfs-files v0.0.8
	github.com/ipfs/go-ipfs-http-client v0.0.5
	github.com/ipfs/go-ipfs-routing v0.1.0
	github.com/ipfs/go-ipfs-util v0.0.2
	github.com/ipfs/go-ipld-cbor v0.0.5
	github.com/ipfs/go-ipld-format v0.2.0
	github.com/ipfs/go-log/v2 v2.3.0
	github.com/ipfs/go-merkledag v0.3.2
	github.com/ipfs/go-metrics-interface v0.0.1
	github.com/ipfs/go-metrics-prometheus v0.0.2
	github.com/ipfs/go-path v0.0.7
	github.com/ipfs/go-unixfs v0.2.6
	github.com/ipfs/interface-go-ipfs-core v0.2.3
	github.com/ipld/go-car v0.1.1-0.20201119040415-11b6074b6d4d
	github.com/ipld/go-car/v2 v2.0.3-0.20210811121346-c514a30114d7
	github.com/ipld/go-ipld-prime v0.5.1-0.20201021195245-109253e8a018
	github.com/kelseyhightower/envconfig v1.4.0
	github.com/libp2p/go-buffer-pool v0.0.2
	github.com/libp2p/go-eventbus v0.2.1
	github.com/libp2p/go-libp2p v0.14.2
	github.com/libp2p/go-libp2p-connmgr v0.2.4
	github.com/libp2p/go-libp2p-core v0.8.6
	github.com/libp2p/go-libp2p-discovery v0.5.1
	github.com/libp2p/go-libp2p-kad-dht v0.11.0
	github.com/libp2p/go-libp2p-mplex v0.4.1
	github.com/libp2p/go-libp2p-noise v0.2.0
	github.com/libp2p/go-libp2p-peerstore v0.2.8
	github.com/libp2p/go-libp2p-pubsub v0.5.4
	github.com/libp2p/go-libp2p-quic-transport v0.11.2
	github.com/libp2p/go-libp2p-record v0.1.3
	github.com/libp2p/go-libp2p-routing-helpers v0.2.3
	github.com/libp2p/go-libp2p-swarm v0.5.3
	github.com/libp2p/go-libp2p-tls v0.1.3
	github.com/libp2p/go-libp2p-yamux v0.5.4
	github.com/libp2p/go-maddr-filter v0.1.0
	github.com/mattn/go-isatty v0.0.13
	github.com/minio/blake2b-simd v0.0.0-20160723061019-3f5f724cb5b1
	github.com/mitchellh/go-homedir v1.1.0
	github.com/multiformats/go-base32 v0.0.3
	github.com/multiformats/go-multiaddr v0.3.3
	github.com/multiformats/go-multiaddr-dns v0.3.1
	github.com/multiformats/go-multibase v0.0.3
	github.com/multiformats/go-multihash v0.0.15
	github.com/multiformats/go-varint v0.0.6
	github.com/open-rpc/meta-schema v0.0.0-20201029221707-1b72ef2ea333
	github.com/opentracing/opentracing-go v1.2.0
	github.com/polydawn/refmt v0.0.0-20190809202753-05966cbd336a
	github.com/prometheus/client_golang v1.10.0
	github.com/raulk/clock v1.1.0
	github.com/raulk/go-watchdog v1.0.1
	github.com/streadway/quantile v0.0.0-20150917103942-b0c588724d25
	github.com/stretchr/testify v1.7.0
	github.com/syndtr/goleveldb v1.0.0
	github.com/urfave/cli/v2 v2.2.0
	github.com/whyrusleeping/bencher v0.0.0-20190829221104-bb6607aa8bba
	github.com/whyrusleeping/cbor-gen v0.0.0-20210713220151-be142a5ae1a8
	github.com/whyrusleeping/ledger-filecoin-go v0.9.1-0.20201010031517-c3dcc1bddce4
	github.com/whyrusleeping/multiaddr-filter v0.0.0-20160516205228-e903e4adabd7
	github.com/whyrusleeping/pubsub v0.0.0-20190708150250-92bcb0691325
	github.com/xorcare/golden v0.6.1-0.20191112154924-b87f686d7542
	go.opencensus.io v0.23.0
	go.uber.org/dig v1.10.0 // indirect
	go.uber.org/fx v1.9.0
	go.uber.org/multierr v1.7.0
	go.uber.org/zap v1.16.0
	golang.org/x/net v0.0.0-20210428140749-89ef3d95e781
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c
	golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c
	golang.org/x/time v0.0.0-20191024005414-555d28b269f0
	golang.org/x/tools v0.1.5
	golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1
	gopkg.in/cheggaaa/pb.v1 v1.0.28
	gotest.tools v2.2.0+incompatible
)

replace github.com/libp2p/go-libp2p-yamux => github.com/libp2p/go-libp2p-yamux v0.5.1

replace github.com/filecoin-project/filecoin-ffi => ./extern/filecoin-ffi

replace github.com/filecoin-project/test-vectors => ./extern/test-vectors

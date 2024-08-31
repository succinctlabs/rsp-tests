# [RSP](https://github.com/succinctlabs/rsp) test fixtures

This repository contains the latest test fixtures for running integration tests or quick demo for [RSP](https://github.com/succinctlabs/rsp).

## Introduction

RSP requires an archive node to operate, which makes it difficult to set up locally, and slow to run with a remote RPC endpoint. This makes it diffcult to run in a CI environment, or for the demo/workshop scenarios.

The solution here is to build an [erpc](https://github.com/erpc/erpc) instance with a pre-populated persistent cache. The cache contains data for all the requests that would be made by RSP when running against the [target blocks](./blocks.json), and therefore enables RSP to run completely offline.

## Using the cache

> [!TIP]
>
> The cache that works for the latest version of RPS against the [target blocks](./blocks.json) is always checked-in to this repository, so [generating a new cache](#generating-cache) is optional.

Clone the repository (use shallow clone to avoid cloning all the historical caches):

```console
git clone --depth 1 https://github.com/succinctlabs/rsp-tests
```

Then, with [Docker Compose](https://docs.docker.com/compose/) installed, run this command inside the repository to bring up the cached `erpc` instance:

```console
docker compose up -d
```

The `erpc` instance would be listening on `0.0.0.0:9545`. The RPC URL for any [supported chain](./blocks.json) is `http://localhost:9545/main/evm/${CHAIN_ID}`.

For example, you may run `rsp` with:

```console
rsp --block-number 18884864 --rpc-url http://localhost:9545/main/evm/1
```

which would execute successfully despite not configuring any upstream RPC, as the cache has been populated with all requests needed.

## Generating cache

To generate a new cache, make sure you've installed:

- [the `rsp` CLI](https://github.com/succinctlabs/rsp?tab=readme-ov-file#installing-the-cli)
- [Docker Compose](https://docs.docker.com/compose/)

Then, [configure RPC](#configuring-rpc) and bring up the cache generation services:

```console
docker compose -f docker-compose.generate.yml up -d
```

Once `erpc` is running, execute the generation script:

```console
./scripts/generate.sh
```

When the script successfully executes, bring down the Docker Compose stack to have Redis write to disk:

```console
docker compose down
```

The resulting `./data/dump.rdb` file is the new cache.

> [!TIP]
>
> `erpc` does not cache responses when block finality is unknown, so the first few responses might not be persisted. Run the generation script twice to ensure cache integrity.

## Configuring RPC

RPC must be configured To [generate a new cache](#generating-cache). It can also be optionally used when [using the cache](#using-the-cache) to provide a fallback for requests not already covered by the cache.

To set up RPC upstreams, simply populate the [.env file](./.env). For example:

```env
RPC_1="http://localhost:8545/"
RPC_2=""
RPC_3=""
RPC_4=""
RPC_5=""
```

The slots `RPC_X` are _not_ chain-specific. `erpc` is capable of automatically detecting chain IDs, so it works as long as at least one upstream is provided for each chain you plan to support.

### Using a hosted RPC provider

In addition to plain HTTP RPC URLs, `erpc` also supports hosted RPC providers via different [upstream types](https://docs.erpc.cloud/config/projects/upstreams). Instead of adding a URL for each network one by one, all networks from a provider can be added at once. For example, to use [Alchemy](https://www.alchemy.com/) for all its supported networks:

```env
RPC_1="evm+alchemy://your-alchemy-api-key-here"
RPC_2=""
RPC_3=""
RPC_4=""
RPC_5=""
```

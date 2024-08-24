# [RSP](https://github.com/succinctlabs/rsp) test fixtures

This repository contains the latest test fixtures for running integration tests or quick demo for [RSP](https://github.com/succinctlabs/rsp).

## Introduction

RSP requires an archive node to operate, which makes it difficult to set up locally, and slow to run with a remote RPC endpoint. This makes it diffcult to run in a CI environment, or for the demo/workshop scenarios.

The solution here is to build an [erpc](https://github.com/erpc/erpc) instance with a pre-populated persistent cache. The cache contains data for all the requests that would be made by RSP when running against the [target blocks](./blocks.json), and therefore enables RSP to run completely offline.

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

When the script successfully executes, bring down the Docker Compose stack to have Redis write to disk. The resulting `./data/dump.rdb` file is the new cache.

## Configuring RPC

RPC must be configured To [generate a new cache](#generating-cache). It can also be optionally used when using the cache to provide a fallback for requests not already covered by the cache.

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

# [RSP](https://github.com/succinctlabs/rsp) test fixtures

This repository contains the latest test fixtures for running integration tests or quick demo for [RSP](https://github.com/succinctlabs/rsp).

## Introduction

RSP requires an archive node to operate, which makes it difficult to set up locally, and slow to run with a remote RPC endpoint. This makes it diffcult to run in a CI environment, or for the demo/workshop scenarios.

The solution here is to build an [erpc](https://github.com/erpc/erpc) instance with a pre-populated persistent cache. The cache contains data for all the requests that would be made by RSP when running against the target blocks, and therefore enables RSP to run completely offline.

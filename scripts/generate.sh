#!/bin/sh

set -e

SCRIPT_DIR=$( cd -- "$( dirname "$0" )" &> /dev/null && pwd )
REPO_ROOT=$( cd -- "$( dirname $( dirname "$0" ) )" &> /dev/null && pwd )

if ! command -v jq >/dev/null 2>&1; then
  echo "Command not found: jq" >&2
  exit 1
fi

if ! command -v rsp >/dev/null 2>&1; then
  echo "Command not found: rsp" >&2
  exit 1
fi

CHAIN_COUNT=$(cat $REPO_ROOT/blocks.json | jq ".chains | length")

# POSIX-compliant for loop
IND_CHAIN=0
while [ $IND_CHAIN -lt $CHAIN_COUNT ]; do
  CHAIN_ID=$(cat $REPO_ROOT/blocks.json | jq ".chains[$IND_CHAIN].chain_id")

  BLOCK_COUNT=$(cat $REPO_ROOT/blocks.json | jq ".chains[$IND_CHAIN].block_numbers | length")

  IND_BLOCK=0
  while [ $IND_BLOCK -lt $BLOCK_COUNT ]; do
    BLOCK_NUMBER=$(cat $REPO_ROOT/blocks.json | jq ".chains[$IND_CHAIN].block_numbers[$IND_BLOCK]")

    echo "Populating cache for chain #${CHAIN_ID} block #${BLOCK_NUMBER}"

    rsp --rpc-url "http://localhost:9545/main/evm/${CHAIN_ID}" --block-number $BLOCK_NUMBER

    IND_BLOCK=$((++IND_BLOCK))
  done

  IND_CHAIN=$((++IND_CHAIN))
done

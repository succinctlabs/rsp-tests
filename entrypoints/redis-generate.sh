#!/bin/sh

set -e

# A clean state for cache generation
if [ -f "/data/dump.rdb" ]; then
  rm /data/dump.rdb
fi

exec docker-entrypoint.sh redis-server

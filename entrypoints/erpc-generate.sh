#!/bin/sh

set -e

cat << EOF > /root/erpc.yaml
logLevel: warn
database:
  evmJsonRpcCache:
    driver: redis
    redis:
      addr: redis:6379
      password: letmein
      db: 0
server:
  httpHost: 0.0.0.0
  httpPort: 9545
projects:
  - id: main
    upstreams:
EOF

if [ -n "$RPC_1" ]; then
  echo "      - endpoint: $RPC_1" >> /root/erpc.yaml
fi

if [ -n "$RPC_2" ]; then
  echo "      - endpoint: $RPC_2" >> /root/erpc.yaml
fi

if [ -n "$RPC_3" ]; then
  echo "      - endpoint: $RPC_3" >> /root/erpc.yaml
fi

if [ -n "$RPC_4" ]; then
  echo "      - endpoint: $RPC_4" >> /root/erpc.yaml
fi

if [ -n "$RPC_5" ]; then
  echo "      - endpoint: $RPC_5" >> /root/erpc.yaml
fi

exec /root/erpc-server

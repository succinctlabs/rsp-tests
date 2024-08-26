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

# Always add in a fake endpoint just to satisfy erpc's requirement of having at least one upstream
# for each network.
cat << EOF >> /root/erpc.yaml
      - endpoint: evm+alchemy://________________________________
        failsafe:
          circuitBreaker:
            # These two variables indicate how many failures and capacity to tolerate before opening the circuit.
            failureThresholdCount: 1
            failureThresholdCapacity: 100
            # How long to wait before trying to re-enable the upstream after circuit breaker was opened.
            halfOpenAfter: 9999999s
            # These two variables indicate how many successes are required in half-open state before closing the circuit,
            # and putting the upstream back in available upstreams.
            successThresholdCount: 100
            successThresholdCapacity: 100
EOF

exec /root/erpc-server

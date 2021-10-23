#!/bin/bash

# Common variables:
export COS_BIN_NAME=chain_daemon_binary_name    # for example: umeed, evmosd, etc
export COS_CHAIN_ID=chain_id_name               # for example: umeevengers-1, evmos_9000-1, etc

# Ports variables (default values, change if needs):
# From config/config.toml
export COS_PORT_PRX=26658
export COS_PORT_RPC=26657
export COS_PORT_P2P=26656
export COS_PORT_PPROF=6060
# From config/app.toml
export COS_PORT_API=1317
export COS_PORT_ROS=8080
export COS_PORT_GRPC=9090
export COS_PORT_GRPCWEB=9091

# Node info:
export COS_MONIKER=my_node_name         # change my_node_name to actual node moniker
export COS_WALLET=my_wallet             # change my_wallet to actual wallet name
export COS_WALADDR=cosmosXX***X         # change to actual wallet adress in used chain format
export COS_VALOPER=cosmosvaloperXX***X  # change to actual valoper adress in used chain format

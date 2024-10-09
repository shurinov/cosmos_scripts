#!/bin/bash

# Common variables:
export COS_BIN_NAME=       # chain daemon binary name, for example: gaiad, etc
export COS_HOME_PATH=      # path to dir with config and data, for example: /home/user/.gaiad
export COS_CHAIN_ID=       # chain id name, for example: cosmoshub-4, etc
export COS_DENOM=          # token denom name, for example: uatom

# Node info:
export COS_MONIKER=    # paste actual node moniker
export COS_WALLET=     # paste actual wallet name
export COS_WALADDR=    # paste actual wallet adress in used chain format
export COS_VALOPER=    # paste actual valoper adress in used chain format

# Node url:
export COS_NODE_URL=localhost

# Ports variables (default values, change if needs):
# From config/config.toml
#export COS_PORT_PRX=26658
export COS_PORT_RPC=26657
export COS_PORT_P2P=26656
#export COS_PORT_PPROF=6060
# From config/app.toml
export COS_PORT_API=1317
#export COS_PORT_ROS=8080
#export COS_PORT_GRPC=9090
#export COS_PORT_GRPCWEB=9091

# Alerts
ALERT_MSG_TITLE="COS NODE"
ALERT_MSG_TAG=""        # tag in notification message (used for easy group node's msg of same chain) 
ALERT_NOT_VALIDATOR=0   # set 1 if node isn't validator (disable checking voting power)
ALERT_NOTIFY_PER_MIN=10
ALERT_LEVEL_TIME_SINCE_BLOCK=30
ALERT_LEVEL_MISSED_BLOCK=30
#
ALERT_TEST=0 # set 1 for activate alert test (RPC status alert)

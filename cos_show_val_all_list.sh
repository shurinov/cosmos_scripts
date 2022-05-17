#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
list_limit=3000 # Magic number for getting list of all validators
${COS_BIN_NAME} q staking validators -o json --limit=${list_limit} --node "tcp://localhost:${COS_PORT_RPC}" \
| jq '.validators[]' | jq -r '.tokens + " - " + .description.moniker' | sort -gr | nl 
popd > /dev/null || exit 1
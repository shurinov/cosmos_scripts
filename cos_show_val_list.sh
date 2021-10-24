#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} q staking validators -o json --limit=1000 --node "tcp://localhost:${COS_PORT_RPC}" | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '.tokens + " - " + .description.moniker' | sort -gr | nl 
popd > /dev/null || exit 1

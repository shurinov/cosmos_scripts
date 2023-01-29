#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
FULL_URL="tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
echo "Missed blocks: `jq -r '.missed_blocks_counter' <<<$($COS_BIN_NAME q slashing signing-info $($COS_BIN_NAME tendermint show-validator --home ${COS_HOME_PATH}) --node=${FULL_URL}  -o json)`"
popd > /dev/null || exit 1

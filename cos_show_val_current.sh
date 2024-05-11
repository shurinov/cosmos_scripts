#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

list_limit=3000

val_pub_key=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status | jq -r .result.validator_info.pub_key.value)

${COS_BIN_NAME} q staking validators -o json --limit=${list_limit} --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" \
| jq -r --arg val_pub_key "$val_pub_key" '.validators[] | select(.consensus_pubkey.key==$val_pub_key)'

popd > /dev/null || exit 1

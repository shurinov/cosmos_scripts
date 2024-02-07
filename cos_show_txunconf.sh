#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

#status=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status)
#net_info=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info)
#curl -s  ${COS_NODE_URL}:${COS_PORT_RPC}/unconfirmed_txs | jq .result.total

mempoolsz=$(curl -s  ${COS_NODE_URL}:${COS_PORT_RPC}/unconfirmed_txs | jq '.result.total | tonumber')
echo -e "Unconfirmed tx pool size: ${GREEN} $mempoolsz ${ST}"


popd > /dev/null || exit 1

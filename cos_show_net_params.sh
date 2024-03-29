#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
ST="\033[0m"

echo -e "${YELLOW}Staking:${ST}"
${COS_BIN_NAME} q staking params --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
echo -e "\n${YELLOW}Slashing:${ST}"
${COS_BIN_NAME} q slashing params --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
popd > /dev/null || exit 1

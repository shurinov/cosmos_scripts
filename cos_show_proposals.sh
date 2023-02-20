#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

# [ param1 ] - proposal number (optional)


RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

if [ -n "$1" ];
then 
  prop_num=$1
  ${COS_BIN_NAME} q gov proposal ${prop_num} --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
else
  ${COS_BIN_NAME} q gov proposals --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
fi

#${COS_BIN_NAME} q gov proposals --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"

popd > /dev/null || exit 1


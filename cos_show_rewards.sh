#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} query distribution rewards ${COS_WALADDR} ${COS_VALOPER} --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" --chain-id ${COS_CHAIN_ID}
popd > /dev/null || exit 1

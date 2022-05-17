#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} query distribution rewards ${COS_WALADDR} ${COS_VALOPER} --node "tcp://127.0.0.1:${COS_PORT_RPC}" --chain-id ${COS_CHAIN_ID}
popd > /dev/null || exit 1

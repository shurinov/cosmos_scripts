#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} query distribution commission ${COS_VALOPER} --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"
popd > /dev/null || exit 1

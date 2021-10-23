#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} query staking validator ${COS_VALOPER} --node "tcp://localhost:${COS_PORT_RPC}"
popd > /dev/null || exit 1

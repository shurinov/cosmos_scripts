#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} query bank balances ${COS_WALADDR} \
  --chain-id=${COS_CHAIN_ID} \
	--node "tcp://127.0.0.1:${COS_PORT_RPC}"
popd > /dev/null || exit 1
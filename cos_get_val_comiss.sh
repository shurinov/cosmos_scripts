#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
password=$1
fees=$2
echo -e "${password}\n" | ${COS_BIN_NAME} tx distribution withdraw-rewards \
  ${COS_VALOPER} \
  --commission \
  --from ${COS_WALLET} \
  --fees=${fees}${COS_DENOM} \
  --chain-id ${COS_CHAIN_ID} \
  --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" \
  --yes
popd > /dev/null || exit 1

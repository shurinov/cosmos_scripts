#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
value=$1
password=$2
fees=$3
echo -e "${password}\n" | ${COS_BIN_NAME} tx staking delegate ${COS_VALOPER} \
  ${value}${COS_DENOM} \
  --from ${COS_WALLET} \
  --chain-id ${COS_CHAIN_ID} \
  --fees=${fees}${COS_DENOM} \
  --node "tcp://127.0.0.1:${COS_PORT_RPC}" \
  --yes
popd > /dev/null || exit 1

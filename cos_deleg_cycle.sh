#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh

wal_name=$1
wal_password=$2
validator=$3
#fees=$2
fees=0
wal_res=500000
timeout=120

while true; do
echo "INFO: Try to get wallet rewards"
echo -e "${wal_password}\n" | ${COS_BIN_NAME} tx distribution withdraw-all-rewards \
  --from ${wal_name} \
  --chain-id ${COS_CHAIN_ID} \
  --fees=${fees}${COS_DENOM} \
  --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" \
  --output json \
  --yes

# sleep 15s
# echo "INFO: Try to get validator comission"
# echo -e "${wal_password}\n" | ${COS_BIN_NAME} tx distribution withdraw-rewards \
  # ${COS_VALOPER} \
  # --commission \
  # --from ${COS_WALLET} \
  # --fees=${fees}${COS_DENOM} \
  # --chain-id ${COS_CHAIN_ID} \
  # --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" \
  # --output json \
  # --yes

sleep 15s

balance=$(${COS_BIN_NAME} q bank balances ${COS_WALADDR} --output json --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" | jq  '.balances[] | select(.denom=="'${COS_DENOM}'") | .amount | tonumber')

to_delegation=$(( $balance-$wal_res ))

echo "INFO: Balance $balance"

if [[ $to_delegation -gt 0 ]]; then
  echo "INFO: Delegate $to_delegation ${COS_DENOM}"
  echo -e "${wal_password}\n" | ${COS_BIN_NAME} tx staking delegate ${validator} ${to_delegation}${COS_DENOM} \
  --from ${wal_name} \
  --chain-id ${COS_CHAIN_ID} \
  --fees=${fees}${COS_DENOM} \
  --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}" \
  --output json \
  --yes
else
  echo "WARN: Not enough tokens!"
fi
echo "INFO: Sleep ${timeout} sec"
sleep ${timeout}

done

popd > /dev/null || exit 1

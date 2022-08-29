#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

case "$1" in
  -h|-help|help) echo -e "Usage: cos_snap_start.sh SNAP_RPC PEERS\n\
  SNAP_RPC - node_ip:rpc_port\n\
  PEERS - peer_id@node_ip:node_p2p_port"; exit 0;;
  *) SNAP_RPC=$1
esac

PEERS=$2

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 3000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo -e "RPC: ${GREEN}$SNAP_RPC${ST}"
# check RPC response
if [ -z "$LATEST_HEIGHT$TRUST_HASH" ];  
then 
  echo -e "${RED}No response from RPC. Exit${ST}"
  exit 0
fi
echo -e "latest height: ${GREEN}$LATEST_HEIGHT${ST}\n\
use block height: ${GREEN}$BLOCK_HEIGHT${ST}, with hash: ${GREEN}$TRUST_HASH${ST}"

# backup configuration file
echo -e "\nBackup ${COS_HOME_PATH}/config/config.toml"
cp ${COS_HOME_PATH}/config/config.toml ${COS_HOME_PATH}/config/$(date +"%F-%H:%M:%S")-bak-config.toml

if [ -n "$PEERS" ];
then 
  # apply PEERS
  echo -e "Update persistent_peers"
  sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ${COS_HOME_PATH}/config/config.toml
else
  echo "Param PEERS is null. Peers didn't changed"
fi

# apply sync state
echo -e "Update state statesync"
sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ${COS_HOME_PATH}/config/config.toml

# print help for next steps
echo -e "\nFor start with new state:\n\
${YELLOW}sudo systemctl stop {service_name}\n\
${COS_BIN_NAME} tendermint unsafe-reset-all --home ${COS_HOME_PATH}\n\
sudo systemctl start {service_name}\n\
journalctl -u {service_name} -f${ST}\n"

popd > /dev/null || exit 1
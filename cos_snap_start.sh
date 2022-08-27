#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

# if [ "$1" == "-h" ]
# then 
  # echo "HELP"
# fi

echo -e "\n"

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

# check (you should see 2 block height and block hash)
echo -e "From RPC: ${GREEN}$LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH${ST}"

# backup configuration file
cp ${COS_HOME_PATH}/config/config.toml ${COS_HOME_PATH}/config/$(date +"%F-%H:%M:%S")-bak-config.toml

if [ -n "$PEERS" ];
then 
  # apply PEERS
  sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ${COS_HOME_PATH}/config/config.toml
else
  echo "Param PEERS is null. Peers didn't changed"
fi

# apply sync state
sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ${COS_HOME_PATH}/config/config.toml

echo "${COS_HOME_PATH}/config/config.toml updated"

echo -e "\nFor start with new state:\n\
${YELLOW}sudo systemctl stop {service_name}\n\
${COS_BIN_NAME} tendermint unsafe-reset-all --home ${COS_HOME_PATH}\n\
sudo systemctl start {service_name}${ST}"

popd > /dev/null || exit 1
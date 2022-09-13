#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

status=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status)
net_info=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info)

if [ -z "$status" ];
then
  echo "ERROR: can't connect to RPC: ${COS_NODE_URL}:${COS_PORT_RPC}">&2
  exit -1
else
  echo -e "${PURPLE}Connect to ${COS_NODE_URL}:${COS_PORT_RPC}${ST}"
fi

network=$(jq -r '.result.node_info.network' <<<$status)
peers_num=$(jq -r '.result.n_peers' <<<$net_info)
moniker=$(jq -r '.result.node_info.moniker' <<<$status)

block_height=$(jq -r '.result.sync_info.latest_block_height' <<<$status)
catching_up=$(jq -r '.result.sync_info.catching_up' <<<$status)
if [ $catching_up == "true" ]
then
  catching_up="${RED}$catching_up${ST}"
else
  catching_up="${GREEN}$catching_up${ST}"
fi

latest_block_time=$(jq -r '.result.sync_info.latest_block_time' <<<$status)
let "time_since_block = $(date +"%s") - $(date -d "$latest_block_time" +"%s")"
if [ $time_since_block -gt 30 ]
then
  block_height="${RED}$block_height${ST}"
  latest_block_time="${RED}$latest_block_time${ST}"
  #time_since_block="${RED}${time_since_block} sec ago${ST}"
else
  block_height="${GREEN}$block_height${ST}"
  latest_block_time="${GREEN}$latest_block_time${ST}"
  #time_since_block="${GREEN}${time_since_block} sec ago${ST}"
fi
time_since_block="${time_since_block} sec ago"

# Output
echo -e ""
echo -e "${PURPLE}INFO:${ST}"
echo -e "Node moniker:   ${YELLOW}$moniker${ST}"
echo -e "Network:        ${YELLOW}$network${ST}"
echo -e "Peers number:   ${YELLOW}$peers_num${ST}"
echo -e ""
echo -e "${PURPLE}SYNC:${ST}"
echo -e "Catching up:    $catching_up"
echo -e ""
echo -e "Latest block    $time_since_block"
echo -e "-height:        $block_height"
echo -e "-time:          $latest_block_time"

# echo -e "Block latest:      $block_height"
# echo -e "Block latest time: $latest_block_time"
# echo -e "Time since latest: $time_since_block"
echo -e ""
popd > /dev/null || exit 1

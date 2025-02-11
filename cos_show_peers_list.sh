#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

if [ "$1" == "--config" ];
then 
  curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info | \
  jq -r '.result.peers[] | [.node_info.id, .node_info.listen_addr, .remote_ip, .node_info.moniker] | @csv' | \
  while IFS=',' read -r id listen_addr remote_ip moniker; do
    # remove commas
    id=${id#\"}
    id=${id%\"}
    remote_ip=${remote_ip#\"}
    remote_ip=${remote_ip%\"}
    listen_addr=${listen_addr#\"}
    listen_addr=${listen_addr%\"}
    moniker=${moniker#\"}
    moniker=${moniker%\"}
    # get port
    port=$(echo "$listen_addr" | rev | cut -d':' -f1 | rev)
    echo -n "tcp://$id@$remote_ip:$port,"
  done | sed 's/,$/\n/'
fi
if [ "$1" == "" ];
then
  echo -e "You can add flag ${PURPLE}--config${ST} to get peers list as configuration string comma-separated\n"
  
  echo -e "${YELLOW}PEER                                                               MONIKER${ST}"
  curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info | \
  jq -r '.result.peers[] | [.node_info.id, .node_info.listen_addr, .remote_ip, .node_info.moniker] | @csv' | \
  while IFS=',' read -r id listen_addr remote_ip moniker; do
    # remove commas
    id=${id#\"}
    id=${id%\"}
    remote_ip=${remote_ip#\"}
    remote_ip=${remote_ip%\"}
    listen_addr=${listen_addr#\"}
    listen_addr=${listen_addr%\"}
    moniker=${moniker#\"}
    moniker=${moniker%\"}
    # get port
    port=$(echo "$listen_addr" | rev | cut -d':' -f1 | rev)
    #echo "tcp://$id@$remote_ip:$port $moniker"
    printf "%-67s%s\n" "$id@$remote_ip:$port" "$moniker"
  done
fi
popd > /dev/null || exit 1
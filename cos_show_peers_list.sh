#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
echo "PEER_ID                                    P2P_LISTEN_ADDR       REMOTE_IP       MONIKER"
curl -s localhost:${COS_PORT_RPC}/net_info | jq -r '.result.peers[] | [.node_info.id, .node_info.listen_addr, .remote_ip, .node_info.moniker] | @csv'
popd > /dev/null || exit 1

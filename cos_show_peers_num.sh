#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
curl -s localhost:${COS_PORT_RPC}/net_info | jq -r '.result.peers[].node_info | [.id, .moniker] | @csv' | wc -l
popd > /dev/null || exit 1

#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
temp_var=$(curl -s localhost:${COS_PORT_RPC}/status | jq .result.node_info.id)\
@$(curl -s localhost:${COS_PORT_RPC}/status | jq .result.node_info.listen_addr)
echo `sed 's/\"//g' <<<"$temp_var"`
popd > /dev/null || exit 1
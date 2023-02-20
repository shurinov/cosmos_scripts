#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
temp_var=`curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status | jq .result.sync_info.latest_block_height`
echo `sed -e 's/^"//' -e 's/"$//' <<<"$temp_var"`
popd > /dev/null || exit 1
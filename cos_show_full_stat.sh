#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status | jq .
popd > /dev/null || exit 1

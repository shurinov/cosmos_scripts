#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
curl -s localhost:${COS_PORT_RPC}/status | jq .
popd > /dev/null || exit 1

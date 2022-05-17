#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
curl -s localhost:${COS_PORT_RPC}/consensus_state | jq '.result.round_state.height_vote_set[0].prevotes_bit_array'
popd > /dev/null || exit 1

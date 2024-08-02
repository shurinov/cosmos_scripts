#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh
cons_state=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/consensus_state | jq -r .result)
round_info=$(echo ${cons_state} | jq -r '.round_state."height/round/step"')
prev_bit_array=$(echo ${cons_state} | jq -r '.round_state.height_vote_set[0].prevotes_bit_array')

#curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/consensus_state | jq '.result.round_state.height_vote_set[0].prevotes_bit_array'
echo -e "height/round/step: ${GREEN} ${round_info}${ST}\n"
echo -e "prevotes_bit_array: ${YELLOW}${prev_bit_array}${ST}\n"

popd > /dev/null || exit 1

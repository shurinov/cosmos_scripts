#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

#  param1 - vote_id
# [param2] - address of vote wallet, by default COS_WALADDR from cos_var.sh

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

cons_state=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/consensus_state | jq -r .result)
tm_short_addr=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status | jq -r .result.validator_info.address[:12])
round_info=$(echo ${cons_state} | jq -r '.round_state."height/round/step"')

echo -e "height/round/step: ${GREEN} ${round_info}${ST}\n"

votes=$(echo ${cons_state} | jq ''| grep ${tm_short_addr} )

#echo -ne $votes | tr ',' '\n'

if [ -z "$votes" ];
then
  echo -e "${RED}HAVE NO VOTES${ST}"
else
  echo -e "${votes//,/$'\n'}"
fi

popd > /dev/null || exit 1


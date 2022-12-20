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

if [ -n "$1" ];
then 
  vote_id=$1
else
  vote_id
  echo -e "${RED}No input parameter vote_id.${ST}\nExit."
  exit 0  
fi

if [ -n "$2" ];
then 
  wal_address=$2
else
  if [ -z ${COS_WALADDR} ]
  then 
    echo -e "${RED}No input parameter and variable COS_WALADDR isn't set in cos_var.sh.${ST}\nExit."
    exit 0
  fi
  wal_address=${COS_WALADDR}
fi

${COS_BIN_NAME} q gov vote ${vote_id} ${wal_address} --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"

popd > /dev/null || exit 1


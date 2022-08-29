#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

if [ -z ${COS_CHAIN_ID} ]
then
  echo -e "${RED}COS_CHAIN_ID isn't set in cos_var.sh.${ST}\nExit."
  exit 0
fi

if [ -z ${COS_PORT_RPC} ]
then
  echo -e "${RED}COS_PORT_RPC isn't set in cos_var.sh.${ST}\nExit."
  exit 0
fi

if [ -n "$1" ];
then 
  wal_address=$1
else
  if [ -z ${COS_WALADDR} ]
  then 
    echo -e "${RED}No input parameter and variable COS_WALADDR isn't set in cos_var.sh.${ST}\nExit."
    exit 0
  fi
  wal_address=${COS_WALADDR}
fi

echo -e "Address:${GREEN}${wal_address}${ST}"

${COS_BIN_NAME} query bank balances ${wal_address} \
  --chain-id=${COS_CHAIN_ID} \
	--node "tcp://127.0.0.1:${COS_PORT_RPC}"
popd > /dev/null || exit 1
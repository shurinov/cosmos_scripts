#!/bin/bash

USER_PWD=$PWD
pushd `dirname ${0}` >/dev/null || exit 1

#  param1 - TYPE 'sdk','namada'
#  param2 - DATA_PATH
#  param3 - SNAP_NAME
#  param4 - COMPRESSION_EXT


RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

now_date() {
  # echo -n $(TZ=":Europe/Novosibirsk" date '+%Y-%m-%d_%H:%M:%S%z')
  echo -n $(TZ=":GMT" date '+%Y-%m-%d_%H:%M:%S%z')
}
log_this() {
  local logging="$@"
  printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}


if [ -n "$1" ];
then 
  TYPE=$1
else
  echo -e "${YELLOW}No input parameters.${ST}\n${GREEN}Usage: ./cos_make_snapshot.sh TYPE DATA_PATH COMPRESSION_EXT SNAP_NAME COMPRESSION_EXT\nCOMPRESSION_EXT = ['lz4', 'zst'] ${ST}\nExit"
  exit 1
fi

if [ -n "$2" ];
then 
  DATA_PATH=$2
else
  if [ -z ${COS_HOME_PATH} ]
  then 
    echo -e "${RED}No input parameter DATA_PATH (target node data directory) and variable COS_HOME_PATH isn't set in cos_var.sh.${ST}"
    echo -e "${YELLOW}Usage: ${ST}"
    exit 1
  fi
  DATA_PATH=${COS_HOME_PATH}
fi

if [ -d ${DATA_PATH} ]; then
  :
else
  echo -e "${RED}Error${ST}\nDATA_PATH ($DATA_PATH) isn't directory"
  exit 1
fi

if [ -n "$3" ];
then 
  SNAP_NAME=$3
fi

if [ -n "$4" ];
then 
  COMPRESSION_EXT=$3
else
  COMPRESSION_EXT="zst"
  #log_this "set default COMPRESSION "${COMPRESSION_EXT}
fi


item=""
until [ -n  "$item" ]
do
echo -ne "IMPORTANT! Stop node before continuing\nIt's stopped? (y/n):"
read item
case "$item" in
    y|Y);;
    *) item=""; echo -e "Exit"; exit 0;
esac
done



COMPRESSION_TYPE=${COMPRESSION_EXT} # by default TYPE=EXT
if [ "$COMPRESSION_EXT" == "zst" ]; then
  COMPRESSION_TYPE="${COMPRESSION_EXT}d" 
  export ZSTD_CLEVEL=3
  export ZSTD_NBTHREADS=6
  log_this "ZSTD_CLEVEL=${ZSTD_CLEVEL} ZSTD_NBTHREADS=${ZSTD_NBTHREADS}"
fi

if [ -z ${SNAP_NAME} ]
then 
  SNAP_NAME='snapshot-'${TYPE}-$(TZ=UTC date +%Y-%m-%dT%H:%M:%S)'.tar.'${COMPRESSION_EXT}
fi

if [[ "$SNAP_NAME" =~ ^/.* ]]; then
  SNAP_OUT=${SNAP_NAME} # if snap name is full path
else
  SNAP_OUT=${USER_PWD}/${SNAP_NAME}
fi

log_this "NODE TYPE: $TYPE"
log_this "COMPRESSION TYPE: $COMPRESSION_TYPE"
log_this "SNAP OUT: $SNAP_OUT"
log_this "DATA PATH: $DATA_PATH"



if [ "$TYPE" == "namada" ]; then
  log_this "start compressing ->"
  OUTPUT=$( { time tar --use-compress-program=${COMPRESSION_TYPE} \
  -cf "${SNAP_OUT}" \
  --directory="$(dirname "${DATA_PATH}")" \
  --exclude="cometbft/config" \
  --exclude="cometbft/data/priv_validator_state.json" \
  --exclude="*.toml" \
  "$(basename "$DATA_PATH")" 2>&1; } 2>&1 )
  log_this "-> finished!\ncompression statistic: ${OUTPUT}"
  log_this "to decompress: tar --use-compress-program=$COMPRESSION_TYPE -xvf snapshot-archive.tar.lz4 -C /destination"
fi


if [ "$TYPE" == "sdk" ]; then
  log_this "start compressing ->"
  OUTPUT=$( { time tar --use-compress-program=${COMPRESSION_TYPE} \
  -cf "${SNAP_OUT}" \
  --directory="$(dirname "${DATA_PATH}")" \
  --exclude="config" \
  --exclude="data/priv_validator_state.json" \
  --exclude="keyring*" \
  --exclude="keyhash" \
  --exclude="*.address" \
  --exclude="*.info" \
  "$(basename "$DATA_PATH")" 2>&1; } 2>&1 )
  log_this "-> finished!\ncompression statistic: ${OUTPUT}"
  log_this "to decompress: tar --use-compress-program=$COMPRESSION_TYPE -xvf snapshot-archive.tar.lz4 -C /destination"
fi


popd > /dev/null || exit 1


#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[33m"
PURPLE='\033[0;35m'
ST="\033[0m"

source ./cos_var.sh

SUBPATH=config
FILENAME=addrbook.json
SRCFILE="${COS_HOME_PATH}/${SUBPATH}/${FILENAME}"

#case "$1" in
#  -h|-help|help) echo -e "Usage: \n\
#  without args - script backup file ${SRCFILE} to same directory\n\
#  with full path to file 
#  "; exit 0;;  
#  *) =$1
#esac


BAKDIR="${COS_HOME_PATH}/${SUBPATH}"
BAKFILENAME="$(date +"%F-%H:%M:%S")-bak-${FILENAME}"
BAKFILE="${BAKDIR}/${BAKFILENAME}"

# backup configuration file
echo -e "\nTry to backup ${SRCFILE}"
echo -e "to ${BAKDIR}"
#res=$(cp ${COS_HOME_PATH}/${SUBPATH}/${FILENAME} ${COS_HOME_PATH}/${SUBPATH}/$(date +"%F-%H:%M:%S")-bak-${FILENAME} 2>&1)
res=$(cp ${SRCFILE} ${BAKFILE} 2>&1)

if [ -z "$res" ];
then 
  echo -e "${GREEN}Success${ST}"
else
  echo -e "${RED}Error:${ST} $res"
fi

popd > /dev/null || exit 1
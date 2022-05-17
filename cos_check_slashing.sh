#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
${COS_BIN_NAME} q slashing signing-info $(${COS_BIN_NAME} tendermint show-validator)
popd > /dev/null || exit 1
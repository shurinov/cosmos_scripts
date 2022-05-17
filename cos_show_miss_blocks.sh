#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh
echo "Missed blocks: `jq -r '.missed_blocks_counter' <<<$($COS_BIN_NAME q slashing signing-info $($COS_BIN_NAME tendermint show-validator) -o json)`"
popd > /dev/null || exit 1

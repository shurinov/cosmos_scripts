#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh

msg_add () {
if [ -z "$msg" ];
then
    msg="${1}"
else
    msg=$(echo -e "${msg}\n${1}")
fi
}

alert=0
#status=$(curl -s ${COS_NODE_URL}:$COS_PORT_RPC/status)

if [ -z "$status" ];
then
    alert=1
    out="Alert! can't connect to node RPC: ${COS_NODE_URL}:$COS_PORT_RPC"
    msg_add "$out"
else
    # get latest block time
    latest_block_time=$(jq -r '.result.sync_info.latest_block_time' <<<$status)
    let "time_since_block = $(date +"%s") - $(date -d "$latest_block_time" +"%s")"
    
    voting_power=$(jq -r '.result.validator_info.voting_power' <<<$status)    
    peers_num=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info | jq -r '.result.n_peers')    
    missed_blocks=$(jq -r '.missed_blocks_counter' <<<$($COS_BIN_NAME q slashing signing-info $($COS_BIN_NAME tendermint show-validator) -o json --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"))
       
    if [ $time_since_block -ge ${ALERT_LEVEL_TIME_SINCE_BLOCK} ];
    then
        alert=1
        out="Alert! time_since_block"
        msg_add "$out"
    fi
    
    if [ ${voting_power} -le 0 ];
    then
        alert=1
        out="Alert! VP"
        msg_add "$out"
    fi
    
    if [ ${missed_blocks} -ge ${ALERT_LEVEL_MISSED_BLOCK} ];
    then
        alert=1
        out="Alert! max_missed_blocks"
        msg_add "$out"
    fi
    
    if [ ${peers_num} -eq 0 ];
    then
        alert=1
        out="Alert! no peers";
        msg_add "$out"
    fi
    
    info=$(echo -e "latest_block_time: ${latest_block_time}
time_since_block: ${time_since_block} sec
voting_power: ${voting_power}
peers_number: ${peers_num}
missed_blocks: ${missed_blocks}")
fi

# convert notify period to sec
let "alerts_notify_period = ${ALERT_NOTIFY_PER_MIN}*60"

# read timestamp file to array
readarray -t arr <cos_alerts_timestamp
ts=${arr[0]}
if [ -z "$ts" ]; then ts=0; fi
let "time_since_alert = $(date +"%s") - ${ts}"
echo "Time since lastest alert: $time_since_alert s"

if [ ${time_since_alert} -ge ${alerts_notify_period} ];
then
    if [ $alert -eq 1 ];
    then 
        echo "SEND ALERT!"
        echo -e $msg
        echo -e $info        
        echo "$(date +"%s")" > cos_alerts_timestamp
        ./scripts_stuff/tgbot_send_msg.sh "${ALERT_MSG_TITLE}" "${msg}" " " "${info}"
    fi
else
    echo "Alert timeout ($alerts_notify_period sec) isn't over"
fi

popd > /dev/null || exit 1








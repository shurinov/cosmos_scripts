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

# assign default alert parameters
if [ -z "${ALERT_MSG_TITLE}" ]; then ALERT_MSG_TITLE="COSMOS ALERT SCRIPT"; fi
if [ -z "${ALERT_NOT_VALIDATOR}" ]; then ALERT_NOT_VALIDATOR=0; fi
if [ -z "${ALERT_NOTIFY_PER_MIN}" ]; then ALERT_NOTIFY_PER_MIN=1; fi
if [ -z "${ALERT_LEVEL_TIME_SINCE_BLOCK}" ]; then ALERT_LEVEL_TIME_SINCE_BLOCK=30; fi
if [ -z "${ALERT_LEVEL_MISSED_BLOCK}" ]; then ALERT_LEVEL_MISSED_BLOCK=30; fi
if [ -z "${ALERT_TEST}" ]; then ALERT_TEST=0; fi


# read missed block value file to array
readarray -t arr <cos_alerts_miss_blocks
missed_prev=${arr[0]}
if [ -z "${missed_prev}" ]; then missed_prev=0; fi
let "missed_level = ${missed_prev} + ${ALERT_LEVEL_MISSED_BLOCK}"

if [ ${ALERT_TEST} -ne 1 ] 
then
    status=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/status)
fi

alert=0
if [ -z "$status" ];
then
    alert=1
    out="Alert! can't connect to node RPC: ${COS_NODE_URL}:$COS_PORT_RPC"
    msg_add "$out"
else
    block_height=$(jq -r '.result.sync_info.latest_block_height' <<<$status)
    # get latest block time
    latest_block_time=$(jq -r '.result.sync_info.latest_block_time' <<<$status)
    let "time_since_block = $(date +"%s") - $(date -d "$latest_block_time" +"%s")"
    
    voting_power=$(jq -r '.result.validator_info.voting_power' <<<$status)    
    peers_num=$(curl -s ${COS_NODE_URL}:${COS_PORT_RPC}/net_info | jq -r '.result.n_peers')    
    missed_blocks=$(jq -r '.missed_blocks_counter' <<<$($COS_BIN_NAME q slashing signing-info $($COS_BIN_NAME tendermint show-validator) -o json --node "tcp://${COS_NODE_URL}:${COS_PORT_RPC}"))
       
    if [ $time_since_block -ge ${ALERT_LEVEL_TIME_SINCE_BLOCK} ];
    then
        alert=1
        out="Alert! time_since_block (limit: ${ALERT_LEVEL_TIME_SINCE_BLOCK})"
        msg_add "$out"
    fi
    
    if [ ${ALERT_NOT_VALIDATOR} -ne 1 ] 
    then
        if [ ${voting_power} -le 0 ];
        then
            alert=1
            out="Alert! VP"
            msg_add "$out"
        fi
        
        if [ ${missed_blocks} -gt ${missed_level} ];
        then
            alert=1
            out="Alert! max_missed_blocks ${missed_prev} > ${missed_blocks} (limit: +${ALERT_LEVEL_MISSED_BLOCK})"
            msg_add "$out"
        fi
        # save current missed blocks 
        echo "${missed_blocks}" > cos_alerts_miss_blocks
    fi
   
    if [ ${peers_num} -eq 0 ];
    then
        alert=1
        out="Alert! no peers";
        msg_add "$out"
    fi
    
    info=$(echo -e "target_rpc: ${COS_NODE_URL}:${COS_PORT_RPC}
latest_block_height: ${block_height}
latest_block_time: ${latest_block_time}
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
    echo -e $info
    if [ $alert -eq 1 ];
    then    
        echo "SEND ALERT!"
        echo -e $msg        
        echo "$(date +"%s")" > cos_alerts_timestamp
        host_ip=$(curl -s -4 --connect-timeout 2 ifconfig.me)
        title="${ALERT_MSG_TITLE} | ${host_ip}"
        
        if [ ${ALERT_TEST} -eq 1 ]; then test_msg="TEST MODE ON"; fi
        
        ./scripts_stuff/tgbot_send_msg.sh "${title}" " " "${msg}" " " "${info}" "" "Notification timeout: ${ALERT_NOTIFY_PER_MIN} min" "${test_msg}"
    fi
else
    echo "Alert timeout ($alerts_notify_period sec) isn't over"
fi

popd > /dev/null || exit 1


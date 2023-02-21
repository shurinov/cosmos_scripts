#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1

msg_add () {
if [ -z "$msg" ];
then
    msg="${1}"
else
    msg=$(echo -e "${msg}\n${1}")
fi
}

# assign default alert parameters
if [ -z "${ALERT_GOV_MSG_TITLE}" ]; then ALERT_GOV_MSG_TITLE="COSMOS GOV ALERT SCRIPT"; fi
#if [ -z "${ALERT_GOV_NOTIFY_PER_MIN}" ]; then ALERT_GOV_NOTIFY_PER_MIN=60; fi
if [ -z "${ALERT_TEST}" ]; then ALERT_TEST=0; fi

# convert notify period to sec
#let "alerts_notify_period = ${ALERT_GOV_NOTIFY_PER_MIN}*60"
# Use short notify period, because Proposal alert happens once for each new proposal. ALERT_GOV_NOTIFY_PER_MIN has no effect
alerts_notify_period=10

# get proposals
props=$(${COS_BIN_NAME} q gov proposals --output=json --node="tcp://${COS_NODE_URL}:$COS_PORT_RPC")

# get some last proposal info
curr_prop=$(jq -r '.proposals[-1]' <<<$props)

p_last_id=$(jq -r '.proposal_id' <<<${curr_prop})
if [ "${p_last_id}" == 'null' ]; then p_last_id=$(jq -r '.id' <<<${curr_prop}); fi

p_last_status=$(jq -r '.status' <<<${curr_prop})

p_last_end_time=$(jq -r '.voting_end_time' <<<${curr_prop})

p_last_title=$(jq -r '.content.title' <<<${curr_prop})
if [ "${p_last_title}" == 'null' ]; then p_last_title=$(jq -r '.messages[0].content.title' <<<${curr_prop}); fi

# debug part
# echo $(jq -r '.proposals[-1]' <<<$props) | jq
# echo ${p_last_id}
# echo ${p_last_status}
# echo ${p_last_title}
# echo ${p_last_end_time}

# read saved data file to array
readarray -t arr <cos_alerts_gov

ts=${arr[0]} # get timestamp
if [ -z "$ts" ]; then ts=0; fi
let "time_since_alert = $(date +"%s") - ${ts}"
echo "Time since lastest alert: $time_since_alert s"

hist_last_id=${arr[1]} # get last known prop's id
if [ -z "${hist_last_id}" ]; then hist_last_id=0; fi

# status assign placeholder
status=1

# variable for writing to file
prop_id2save=${hist_last_id}
alert=0

# Test mode alert emulation
if [ ${ALERT_TEST} -eq 1 ] 
then
  alert=1
fi

if [ -z "$status" ];
then
    alert=1
    out="Alert! status"
    msg_add "$out"
else 
  # check last proposal ID
  if [ ${p_last_id} -gt ${hist_last_id} ];
  then
    echo "Set alert to 1 ${p_last_id} greater than ${hist_last_id}"    
    alert=1
    out=$(echo -ne "New proposal: ${p_last_id} (previous last: ${hist_last_id})\n\nSTATUS: ${p_last_status}\nTITLE: ${p_last_title}\nEND TIME: ${p_last_end_time}\n")
    msg_add "$out"    
    prop_id2save=${p_last_id}
  fi
fi

echo -e $msg

if [ ${time_since_alert} -ge ${alerts_notify_period} ];
then
  if [ $alert -eq 1 ];
  then    
    echo "SEND ALERT!"
    
    echo "$(date +"%s")" > cos_alerts_gov
    echo "${prop_id2save}" >> cos_alerts_gov
    host_ip=$(curl -s --connect-timeout 2 ifconfig.me)
    title="${ALERT_GOV_MSG_TITLE} | ${host_ip}"      
    if [ ${ALERT_TEST} -eq 1 ]; then test_msg="TEST MODE ON"; fi
    ./scripts_stuff/tgbot_send_msg.sh "${title}" " " "${msg}" "" "Notification timeout: disable" "${test_msg}"
  else
    echo "No alert last prop id: ${p_last_id}, saved: ${hist_last_id}"
  fi
else
  echo "Alert timeout ($alerts_notify_period sec) isn't over"
fi 

popd > /dev/null || exit 1

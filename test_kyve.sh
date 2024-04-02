#!/bin/bash
pushd `dirname ${0}` >/dev/null || exit 1
source ./cos_var.sh




kyve_pool_data="initvalue"
i=0
while [ "$kyve_pool_data" != "null" ]
do
  kyve_pool_data=$(curl -s http://${COS_NODE_URL}:${COS_PORT_API}/kyve/query/v1beta1/staker/${COS_KYVE_STAKER_ADDR} | \
 jq -r --arg jq_var_i $i '.staker.pools[$jq_var_i | tonumber]')

  if [ "$kyve_pool_data" != "null" ]
  then
    kyve_staker_points=$(jq -r '.points | tonumber' <<<${kyve_pool_data})
    #echo $kyve_staker_points
    if [ $kyve_staker_points -ne 0 ];
    then 
      alert=1
      out="Alert! KYVE points: ${kyve_staker_points}";
      echo "$out"
      echo "${kyve_staker_pools}"
      echo "$msg"
    fi
  fi
    
  i=$(expr $i + 1)
done 

if [ -z "$kyve_staker_points" ];
then
  alert=1
  out="Alert! KYVE no staker pools";
  echo "$out"
fi

 
#



popd > /dev/null || exit 1


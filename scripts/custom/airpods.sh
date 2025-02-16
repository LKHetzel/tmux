#!/usr/local/bin/bash
# Airpods.sh
# Output connected Airpods battery levels via CLI

AIRPOD_ICON=$'\uF7CC';

BATTERY_INFO=(
  "BatteryPercentCombined" 
  "HeadsetBattery" 
  "BatteryPercentSingle" 
  "BatteryPercentCase" 
  "BatteryPercentLeft" 
  "BatteryPercentRight"
)

BT_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth)
SYS_PROFILE=$(system_profiler SPBluetoothDataType 2>/dev/null)
MAC_ADDR=$(grep -b2 "Minor Type: Headphones"<<<"${SYS_PROFILE}"|awk '/Address/{print $3}')
CONNECTED=$(grep -ia6 "${MAC_ADDR}"<<<"${SYS_PROFILE}"|awk '/Connected: Yes/{print 1}')
BT_DATA=$(grep -ia6 '"'"${MAC_ADDR}"'"'<<<"${BT_DEFAULTS}")

if [[ "${CONNECTED}" ]]; then
  for info in "${BATTERY_INFO[@]}"; do
    declare -x "${info}"="$(awk -v pat="${info}" '$0~pat{gsub (";",""); print $3 }'<<<"${BT_DATA}")"
    [[ ! -z "${!info}" ]] && OUTPUT="${OUTPUT} $(awk '/BatteryPercent/{print substr($0,15)": "}'<<<"${info}")${!info}%"
  done
   echo "${AIRPOD_ICON} ${OUTPUT}"
else
  echo "Not Connected ${OUTPUT}"
fi


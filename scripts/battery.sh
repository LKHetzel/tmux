#!/usr/bin/env bash

linux_acpi() {
    arg=$1
    BAT=$(ls -d /sys/class/power_supply/BAT* | head -1)
    if [ ! -x "$(which acpi 2> /dev/null)" ];then
        case "$arg" in
            status)
                cat $BAT/status
            ;;

            percent)
                cat $BAT/capacity
            ;;

            *)
            ;;
        esac
    else
        case "$arg" in
            status)
                acpi | cut -d: -f2- | cut -d, -f1 | tr -d ' '
            ;;
            percent)
                acpi | cut -d: -f2- | cut -d, -f2 | tr -d '% '
            ;;
            *)
            ;;
        esac
    fi
}

battery_percent()
{
	# Check OS
	case $(uname -s) in
		Linux)
			percent=$(linux_acpi percent)
			[ -n "$percent" ] && echo " $percent"
		;;

		Darwin)
			echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac
}

battery_status()
{
	# Check OS
	case $(uname -s) in
		Linux)
            status=$(linux_acpi status)
		;;

		Darwin)
			status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac

	if [ $status = 'discharging' ] || [ $status = 'Discharging' ]; then
		echo ''
	else
	 	echo 'AC'
	fi
}

airpods_status() {
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
   		printf "%s\\n" "${AIRPOD_ICON} ${OUTPUT}"
	else
  		printf "%s Not Connected\\n" "${OUTPUT}"
	fi
}

main()
{
	airpods=$(airpods_status)
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)

	if [ -z "$bat_stat" ]; then # Test if status is empty or not
		echo "♥ $bat_perc"
	elif [ -z "$bat_perc" ]; then # In case it is a desktop with no battery percent, only AC power
		echo "♥ $bat_stat"
	else
		echo "♥ $bat_stat $bat_perc "
	fi
	echo "$airpods"
}

#run main driver program
main


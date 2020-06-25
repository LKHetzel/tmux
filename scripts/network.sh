#!/usr/bin/env bash

HOSTS="google.com github.com example.com"
WIFI_SYMBOL=$'\uF09E';
ETH_SYMBOL=$'\uF877';
get_ssid()
{
	# Check OS
	case $(uname -s) in
		Linux)
			SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
			if [ -n "$SSID" ]; then
				printf '%s %s' "$WIFI_SYMBOL" "$SSID"
			else
				echo 'Ethernet'
			fi
		;;

		Darwin)
			if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2 | sed 's/ ^*//g' &> /dev/null; then
				SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)
				printf "%s %s" "$WIFI_SYMBOL" "$SSID"
			else
				printf "%s - Ethernet" "$ETH_SYMBOL"
			fi
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac

}

main()
{
	network="Offline"
	for host in $HOSTS; do
	    if ping -q -c 1 -W 1 $host &>/dev/null; then
		    network=" $(get_ssid)"
		    break
	    fi
	done

	echo "$network"
}

#run main driver function
main

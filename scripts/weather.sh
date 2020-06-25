#!/bin/bash
#
# Weather
# =======
#
# By Jezen Thomas <jezen@jezenthomas.com>
#
# This script sends a couple of requests over the network to retrieve
# approximate location data, and the current weather for that location. This is
# useful if for example you want to display the current weather in your tmux
# status bar.

# There are three things you will need to do before using this script.
#
# 1. Install jq with your package manager of choice (homebrew, apt-get, etc.)
# 2. Sign up for a free account with OpenWeatherMap to grab your API key
# 3. Add your OpenWeatherMap API key where it says API_KEY

# OPENWEATHERMAP API KEY (place yours here)
API_KEY="412a6516f506201b00a7bc576cdd287a"

set -e

# Not all icons for weather symbols have been added yet. If the weather
# category is not matched in this case statement, the command output will
# include the category ID. You can add the appropriate emoji as you go along.
#
# Weather data reference: http://openweathermap.org/weather-conditions
weather_icon() {
  case $1 in
    # Group 2xx: Thunderstorms
    200) echo 
      ;;
    # Group 3xx: Drizzle
    300) echo 
      ;;
    # Group 5xx: Rain
    500) echo 
      ;;
    # Group 6xx: Snow
    600) echo 
      ;;
    # Group 800: Clear
    800) echo 
      ;;
      # Group 80x: Clouds
    801) echo 
      ;;
    803) echo 
      ;;
    804) echo 
      ;;
    *) echo "$1"
  esac
}

LOCATION=$(curl --silent http://ip-api.com/csv)
CITY=$(echo "Indianapolis" | cut -d , -f 6)
LAT=$(echo "$LOCATION" | cut -d , -f 8)
LON=$(echo "$LOCATION" | cut -d , -f 9)


WEATHER=$(curl --silent http://api.openweathermap.org/data/2.5/weather\?q="$CITY"\&APPID="$API_KEY"\&units=imperial)

CATEGORY=$(echo "$WEATHER" | jq .weather[0].id)
TEMP="$(echo "$WEATHER" | jq .main.temp | cut -d . -f 1)°F"
WIND_SPEED="$(echo "$WEATHER" | jq .wind.speed | awk '{print int($1+0.5)}')ms"
ICON=$(weather_icon "$CATEGORY")

main()
{
	# process should be cancelled when session is killed
	if ping -q -c 1 -W 1 ipinfo.io &>/dev/null; then
		printf "%s" "$CITY $ICON $TEMP"
	else
		echo "Location Unavailable"
	fi
}

#run main driver program
main

#!/usr/bin/env bash

# TODO: Refactor into functions

# Error codes
CODE_SUCCESS=0
CODE_FAIL=1
CODE_FAILED_TO_FETCH_CONN=2

# Constant variables
DISCONNECT=" Disconnect"
DISABLE_WIFI="󰖪 Disable Wi-Fi"
ENABLE_WIFI="󰖩 Enable Wi-Fi"
SCAN_WIFI=" Scan for wifi networks"
DISABLE_CONN="󰂭  Disable connection"
ENABLE_CONN="󰈀 Enable connection"

connector=""
connected_to=""
connection_type=""
toggle="$DISABLE_WIFI"

connection_details=$(nmcli | grep -i "connected to")
if [[ -z "$connection_details" ]]; then
	echo "Not connected to wifi"
	wifi_field=$(nmcli -fields WIFI g)
	if [[ "$wifi_field" =~ "disabled" ]]; then
		toggle="$ENABLE_WIFI"
	fi
	all_devices=$(nmcli -t -f DEVICE,TYPE,STATE device)
	# Check if wifi devices are present
	wlan_device=$(echo "$all_devices" | awk -F':' '{ printf "%s\n", $1 }' | grep -v "p2p-dev-" | grep "wlan[0-9]" | head -n1 )
	if [[ -z "$wlan_device" ]]; then
		echo "No wifi devices are found"
		notify-send "No wifi devices are found"
	else
		connector=$wlan_device
		network_list=$(nmcli device wifi rescan ifname $connector && nmcli -t -f SECURITY,SIGNAL,SSID device wifi list)
		if [[ -z "$network_list" ]]; then
			echo "No networks found, used device $connector"
			notify-send "No networks found"
		fi
		prettified_menu=$(echo "$network_list" | awk -F':' '{lock=($1 == "" ? "" : "")
		sym=($2 < 10 ? "󰤠" : ($2 < 30 ? "󰤟" : ($2 < 50 ? "󰤢" : ($2 < 75 ? "󰤥" : "󰤨"))))
		printf "%s %s %s\n", lock, sym, $3}')
		selection=$(echo -e "$toggle\n$prettified_menu" | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID:")
		if [ "$selection" == "$DISCONNECT" ]; then
			nmcli connection down $connected_to | grep "successfully" & notify-send "Disconnected from $connected_to"
		elif [ "$selection" == "$ENABLE_WIFI" ]; then
			nmcli radio wifi on
		else 
			read -r chosen_ssid <<< "${selection:3}"
			saved_connections=$(nmcli -g NAME connection)
			if [[ $(echo "$saved_connections" | grep -w "$chosen_ssid") = "$chosen_ssid" ]]; then
				nmcli connection up id "$chosen_ssid" | grep "successfully" && notify-send "Connected to $chosen_ssid"
			else
				if [[ "$selection" =~ "" ]]; then
					password=$(rofi -dmenu -p "Password: ")
					nmcli device wifi connect "$chosen_ssid" password $password | grep "successfully" && notify-send "Connected to $chosen_ssid"
				else
					nmcli device wifi connect "$chosen_ssid" | grep "successfully" && notify-send "Connected to $chosen_ssid"
				fi
			fi
		fi

	fi


else
	short_str=$(echo "$connection_details" | sed -r 's/ connected to //g')
	connector=$(echo "$short_str" | awk -F':' '{ printf "%s", $1 }')
	connected_to=$(echo "$short_str" | awk -F':' '{ printf "%s", $2 }')
	if [[ ! -z $(echo "$connector" | grep "wlan[0-9]") ]]; then
		echo "Wlan detected"
		connection_type="wlan"
		network_list=$(nmcli device wifi rescan ifname $connector && nmcli -t -f SECURITY,SIGNAL,SSID device wifi list)
		if [[ -z "$network_list" ]]; then
			echo "No networks found, used device $connector"
			notify-send "No networks found"
		fi
		echo $network_list
		prettified_menu=$(echo "$network_list" | awk -F':' '{lock=($1 == "" ? "" : "")
		sym=($2 < 10 ? "󰤠" : ($2 < 30 ? "󰤟" : ($2 < 50 ? "󰤢" : ($2 < 75 ? "󰤥" : "󰤨"))))
		printf "%s %s %s\n", lock, sym, $3}')
		selection=$(echo -e "$DISCONNECT\n$toggle\n$prettified_menu" | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID:")
		if [ "$selection" == "$DISCONNECT" ]; then
			nmcli connection down $connected_to | grep "successfully" & notify-send "Disconnected from $connected_to"
		elif [ "$selection" == "$DISABLE_WIFI" ]; then
			nmcli radio wifi off
		else 
			read -r chosen_ssid <<< "${selection:3}"
			saved_connections=$(nmcli -g NAME connection)
			if [[ $(echo "$saved_connections" | grep -w "$chosen_ssid") = "$chosen_ssid" ]]; then
				nmcli connection up id "$chosen_ssid" | grep "successfully" && notify-send "Connected to $chosen_ssid"
			else
				if [[ "$selection" =~ "" ]]; then
					password=$(rofi -dmenu -p "Password: ")
					nmcli device wifi connect "$chosen_ssid" password $password | grep "successfully" && notify-send "Connected to $chosen_ssid"
				else
					nmcli device wifi connect "$chosen_ssid" | grep "successfully" && notify-send "Connected to $chosen_ssid"
				fi
			fi
		fi

	elif [[ ! -z $(echo "$connector" | grep "enp[0-9]s[0-9]") ]]; then
		echo "Ethernet detected"
		connection_type="ethernet"
		selection=$(echo "$DISCONNECT\n$connected_to")
		if [ "$selection" == "$DISCONNECT" ]; then
			nmcli connection down $connected_to
		else
			exit 0
		fi
	else
		echo "Unknown connector: $connector"
		notify-send "Failed to determine connector type"
		exit 1
	fi
fi

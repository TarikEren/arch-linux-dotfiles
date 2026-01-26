#!/usr/bin/env bash

# Global variables
menu=""
connection_type=""
wifi_exists=""
ethernet_exists=""

# Constant variables
DISABLE_WIFI="󰖪 Disable wifi"
ENABLE_WIFI="󰖩 Enable wifi"
SCAN_WIFI=" Scan for wifi networks"
DISABLE_CONN="󰂭  Disable connection"
ENABLE_CONN="󰈀 Enable connection"
WIFI_NETWORKS_NOT_FOUND="Couldn't find any wifi networks"

# Functions
check_connection_type() {
	local connection=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -n1 | grep -e "wlan*" -e "enp3s*")
	if [[ $connection == *"wlan"* ]]; then
		echo "Wireless connection detected"
		connection_type="wireless"

	elif [[ $connection == *"enp3s"* ]]; then
		echo "Wired connection detected"
		connection_type="ethernet"
	else
		echo "No connection detected"
		connection_type="none"
	fi
}

check_wifi_chipset() {
	local result=$(lspci | grep -i "network")
	if  [[ -z "$result" ]]; then
		echo "Wireless controller not found"
		wifi_exists=false
	else
		
		echo "Wireless controller exists"
		wifi_exists=true
	fi
}

check_ethernet_controller() {
	local result=$(lspci | grep -i "ethernet")
	if [[ -z "$result" ]]; then
		echo "Ethernet controller not found"
		eth_exists=false
	else
		echo "Ethernet controller exists"
		eth_exists=true
	fi
}

scan_wifi_networks() {
	# TODO: Scan for wifi networks
}

format_wifi_networks() {
	# TODO: Based on the strength of the signal add the correct wifi 
	# icon
	# TODO: Add a lock icon if the network has security, an opened
	# lock icon if not
}

# Main section
check_wifi_chipset
check_ethernet_controller
check_connection_type
scan_wifi_networks

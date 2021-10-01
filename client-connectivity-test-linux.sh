#!/bin/bash
set -e

# TODO: IPv6
# TODO: This code should be refactored

# This script contains many static IP's that may be outdated if K-Net is updated/changed and this script is not.

echo "Welcome to K-Net Script for IPv4 Client connectivity testing. Version 0.0.1-alpha."
echo ""

echo "Check required packages are installed"

echo "Is ping installed?"
which ping 2>&1 >/dev/null
echo "OK"

echo "Is dig installed?"
which dig 2>&1 >/dev/null
echo "OK"

echo "Is dhclient installed?"
which dhclient 2>&1 >/dev/null
echo "OK"

echo "Is sed installed?"
which sed 2>&1 >/dev/null
echo "OK"

echo "Check no 1: Can renew DHCP lease and get K-Net IP"
echo ""

echo "Release lease"
sudo dhclient -r

echo "Renew lease"
sudo dhclient

# Wait for DHCP lease

# Please note Alpha version does not check for 185.140.0.0/22 ip
echo "Check IP is an K-Net IP 82.211.192.0/19 (checking) or 185.140.0.0/22 (TODO)"
while [[ $(hostname -I | sed 's/ /\n/g' | grep -E "82\.211\.(19[2-9]|2[0-1][0-9]|22[0-3]).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)") == "" ]]
do
    sleep 1
done


echo "Check no 2: Ping internal servers that must be reachable"
echo ""

echo "Ping Jeltz"
ping -c 1 82.211.192.6 2>&1 >/dev/null
echo "OK"

echo "Ping Arthur"
ping -c 1 82.211.192.242 2>&1 >/dev/null
echo "OK"

echo "Ping K-Net edge server IP's"
ping -c 1 82.211.192.2 2>&1 >/dev/null
echo "OK"
ping -c 1 217.63.127.243 2>&1 >/dev/null
echo "OK"

echo "Ping DNS server IP's"
ping -c 1 82.211.192.242 2>&1 >/dev/null
echo "OK"
ping -c 1 82.211.192.246 2>&1 >/dev/null
echo "OK"

echo "Check no 3: Verify DNS works"
echo ""

echo "Lookup dr.dk"
dig a dr.dk @82.211.192.242 2>&1 >/dev/null
echo "OK"
dig a dr.dk @82.211.192.246 2>&1 >/dev/null
echo "OK"

echo "Lookup google.com"
dig a google.com @82.211.192.242 2>&1 >/dev/null
echo "OK"
dig a google.com @82.211.192.246 2>&1 >/dev/null
echo "OK"


echo "Check no 4: Check for internet reachability"
echo ""

echo "Ping known external IP"
ping -c 1 1.1.1.1 2>&1 >/dev/null
echo "OK"

#!/bin/bash

# script to check if ttl and hl have been changed
# to verify if verizon hotspot throttling is bypassed

echo "=== Current TTL/HL Settings ==="

echo "IPv4 TTL rules:"
iptables -t mangle -L -n -v | grep -i ttl || echo "No TTL rules found"

echo ""

echo "IPv6 HL (Hop Limit) rules:"
ip6tables -t mangle -L -n -v | grep -i hl || echo "No HL rules found"

echo ""

echo "System default TTL/HL values:"
if [ -f /proc/sys/net/ipv4/ip_default_ttl ]; then
    echo "IPv4 default TTL: $(cat /proc/sys/net/ipv4/ip_default_ttl)"
fi

if [ -f /proc/sys/net/ipv6/conf/all/hop_limit ]; then
    echo "IPv6 default HL: $(cat /proc/sys/net/ipv6/conf/all/hop_limit)"
fi

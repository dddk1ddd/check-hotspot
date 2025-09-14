#!/bin/bash

ipv4_default_ttl=""
ipv6_default_hl=""

if [ -f /proc/sys/net/ipv4/ip_default_ttl ]; then
    ipv4_default_ttl=$(cat /proc/sys/net/ipv4/ip_default_ttl)
fi

if [ -f /proc/sys/net/ipv6/conf/all/hop_limit ]; then
    ipv6_default_hl=$(cat /proc/sys/net/ipv6/conf/all/hop_limit)
fi

current_ttl_rules=$(iptables -t mangle -L -n -v 2>/dev/null | grep -i ttl | head -1)
current_hl_rules=$(ip6tables -t mangle -L -n -v 2>/dev/null | grep -i hl | head -1)

current_ttl="default"
if [ ! -z "$current_ttl_rules" ]; then
    current_ttl=$(echo "$current_ttl_rules" | grep -oE 'TTL set to [0-9]+' | grep -oE '[0-9]+')
    if [ -z "$current_ttl" ]; then
        current_ttl="unknown"
    fi
fi

current_hl="default"
if [ ! -z "$current_hl_rules" ]; then
    current_hl=$(echo "$current_hl_rules" | grep -oE 'HL set to [0-9]+' | grep -oE '[0-9]+')
    if [ -z "$current_hl" ]; then
        current_hl="unknown"
    fi
fi

printf "TTL Modified / Default - HL Modified / Default\n"
printf "%8s/%-8s - %8s/%-8s\n" "$current_ttl" "$ipv4_default_ttl" "$current_hl" "$ipv6_default_hl"

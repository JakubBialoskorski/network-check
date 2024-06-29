#!/bin/bash

get_ip() {
    ifconfig $1 | grep 'inet ' | awk '{print $2}'
}

convert_subnet() {
    hex=$(ifconfig $1 | grep 'inet ' | awk '{print $4}')
    printf "%d.%d.%d.%d" \
        $(( (hex >> 24) & 0xff )) \
        $(( (hex >> 16) & 0xff )) \
        $(( (hex >> 8) & 0xff )) \
        $(( hex & 0xff ))
}

get_gateway() {
    netstat -nr | grep 'default' | grep $1 | awk '{print $2}'
}

for iface in $(ifconfig -l); do
    if [ "$iface" != "lo0" ]; then
        ip=$(get_ip $iface)
        if [ -n "$ip" ]; then
            echo "Interface: $iface"
            echo "IP Address: $ip"
            echo "Subnet Mask: $(convert_subnet $iface)"
            echo "Gateway: $(get_gateway $iface)"
            echo "---------------------------"
        fi
    fi
done


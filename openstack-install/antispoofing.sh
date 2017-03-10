#!/bin/bash
NET_P1=$(neutron port-list|grep 10.0.0.8|awk '{print $2}')
NET_P2=$(neutron port-list|grep '192.168.1.1"'|awk '{print $2}')

neutron port-update --no-security-groups --port-security-enabled=False $NET_P1
neutron port-update --no-security-groups --port-security-enabled=False $NET_P2

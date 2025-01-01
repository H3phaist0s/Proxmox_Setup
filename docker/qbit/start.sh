#!/bin/sh

if [ "$(sysctl -n net.ipv4.conf.all.src_valid_mark)" != "1" ]; then
    echo "Error: net.ipv4.conf.all.src_valid_mark must be set to 1"
    exit 1
fi

# Start OpenVPN in the background
openvpn --config /etc/openvpn/config/config.ovpn --auth-user-pass /etc/openvpn/config/auth.txt --auth-nocache &

# Wait for VPN interface
while : ; do
    if ip link show tun0 >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
# Allow OpenVPN traffic to endpoint
iptables -A OUTPUT -p udp -d 107.150.23.131 --dport 443 -j ACCEPT
iptables -A INPUT -p udp -s 107.150.23.131 --sport 443 -j ACCEPT
# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allow web UI access on port 8080
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 8080 -j ACCEPT
# Allow all traffic through VPN
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT
# Allow DNS (through VPN after connection)
iptables -A OUTPUT -o tun0 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i tun0 -p udp --sport 53 -j ACCEPT

# Start qBittorrent
qbittorrent-nox --webui-port=8080 --profile=/config

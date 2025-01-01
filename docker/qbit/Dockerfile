FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    qbittorrent-nox \
    openvpn \
    iptables

# Create directory for wireguard config
RUN mkdir -p /etc/openvpn

# Create directory for qBittorrent config
RUN mkdir -p /config/.qbittorrent

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Default ports for qBittorrent
EXPOSE 8080 40069/tcp 40069/udp

# Volume mounts for persistent data
VOLUME ["/downloads", "/config"]

# Start script that handles VPN and qBittorrent
CMD ["/start.sh"]

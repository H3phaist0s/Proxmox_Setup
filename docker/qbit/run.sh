docker run -d \
  --name=torrent-vpn \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --sysctl net.ipv4.conf.all.src_valid_mark=1 \
  -v ./openvpn/config:/etc/openvpn/config \
  -v ./downloads:/downloads \
  -v ./config:/config \
  -p 8080:8080 \
  -p 40069:40069 \
  --privileged \
  secure-torrent

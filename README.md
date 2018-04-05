## With VPN provided by Private Internet Access

### Usage
```
docker run \
--detach \
--name qbittorrent \
--dns 209.222.18.222 \
--dns 209.222.18.218 \
--cap-add NET_ADMIN \
--device /dev/net/tun \
--publish 8080:8080 \
--env "OPENVPN_USERNAME=**username**" \
--env "OPENVPN_PASSWORD=**password**" \
--volume qbittorrent-config:/config \
--volume qbittorrent-data:/data \
bmoorman/qbittorrent:latest
```

## Without VPN

### Usage
```
docker run \
--detach \
--name qbittorrent \
--publish 8080:8080 \
--volume qbittorrent-config:/config \
--volume qbittorrent-data:/data \
bmoorman/qbittorrent:novpn
```

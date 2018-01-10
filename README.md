## With VPN provided by Private Internet Access

### Usage
```
docker run \
--rm \
--detach \
--init \
--cap-add NET_ADMIN \
--device /dev/net/tun \
--name qbittorrent-public \
--hostname qbittorrent-public \
--volume qbittorrent-public-config:/config \
--volume qbittorrent-public-data:/data \
--publish 8080:8080 \
--dns 209.222.18.222 \
--dns 209.222.18.218 \
--env "OPENVPN_USERNAME=**username**" \
--env "OPENVPN_PASSWORD=**password**" \
bmoorman/qbittorrent
```

## Without VPN

### Usage
```
docker run \
--rm \
--detach \
--init \
--name qbittorrent-public \
--hostname qbittorrent-public \
--volume qbittorrent-public-config:/config \
--volume qbittorrent-public-data:/data \
--publish 8080:8080 \
bmoorman/qbittorrent:novpn
```

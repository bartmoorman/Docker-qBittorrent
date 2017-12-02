### Usage - Public Trackers
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

### Usage - Private Trackers
```
docker run \
--rm \
--detach \
--init \
--cap-add NET_ADMIN \
--device /dev/net/tun \
--name qbittorrent-private \
--hostname qbittorrent-private \
--volume qbittorrent-private-config:/config \
--volume qbittorrent-private-data:/data \
--publish 8081:8081 \
--dns 209.222.18.222 \
--dns 209.222.18.218 \
--env "OPENVPN_USERNAME=**username**" \
--env "OPENVPN_PASSWORD=**password**" \
--env "QBITTORRENT_WEBUI_PORT=8081" \
bmoorman/qbittorrent
```

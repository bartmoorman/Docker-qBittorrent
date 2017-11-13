### Public Trackers
```
docker run \
--rm \
--detach \
--init \
--name qbittorrent-public \
--hostname qbittorrent-public \
--volume qbittorrent-public-data:/data \
--volume qbittorrent-public-config:/config \
--publish 8080:8080 \
bmoorman/qbittorrent:no-openvpn
```

### Private Trackers
```
docker run \
--rm \
--detach \
--init \
--name qbittorrent-private \
--hostname qbittorrent-private \
--volume qbittorrent-private-data:/data \
--volume qbittorrent-private-config:/config \
--publish 8081:8081 \
--env "QBITTORRENT_WEBUI_PORT=8081" \
bmoorman/qbittorrent:no-openvpn
```

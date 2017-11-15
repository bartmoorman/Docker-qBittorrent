### Public Trackers
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
--volume qbittorrent-private-config:/config \
--volume qbittorrent-private-data:/data \
--publish 8081:8081 \
--env "QBITTORRENT_WEBUI_PORT=8081" \
bmoorman/qbittorrent:no-openvpn
```

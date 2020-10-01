## With VPN provided by Private Internet Access

### Docker Run
```
docker run \
--detach \
--name qbittorrent \
--dns 1.1.1.1 \
--dns 1.0.0.1 \
--cap-add NET_ADMIN \
--device /dev/net/tun \
--publish 8080:8080 \
--env "OPENVPN_USERNAME=**username**" \
--env "OPENVPN_PASSWORD=**password**" \
--volume qbittorrent-config:/config \
--volume qbittorrent-data:/data \
bmoorman/qbittorrent:latest
```

### Docker Compose
```
version: "3.7"
services:
  qbittorrent:
    image: bmoorman/qbittorrent:latest
    container_name: qbittorrent
    dns:
      - 1.1.1.1
      - 1.0.0.1
    cap_add:
      - NET_ADMIN
    devices:
      - "/dev/net/tun"
    ports:
      - "8080:8080"
    environment:
      - OPENVPN_USERNAME=**username**
      - OPENVPN_PASSWORD=**password**
    volumes:
      - qbittorrent-config:/config
      - qbittorrent-data:/data

volumes:
  qbittorrent-config:
  qbittorrent-data:
```

## Without VPN

### Docker Run
```
docker run \
--detach \
--name qbittorrent \
--publish 8080:8080 \
--volume qbittorrent-config:/config \
--volume qbittorrent-data:/data \
bmoorman/qbittorrent:novpn
```

### Docker Compose
```
version: "3.7"
services:
  qbittorrent:
    image: bmoorman/qbittorrent:novpn
    container_name: qbittorrent
    ports:
      - "8080:8080"
    volumes:
      - qbittorrent-config:/config
      - qbittorrent-data:/data

volumes:
  qbittorrent-config:
  qbittorrent-data:
```

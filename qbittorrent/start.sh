#!/bin/bash
$(which qbittorrent-nox) \
    --webui-port=${QBITTORRENT_WEBUI_PORT} \
    --daemon

/etc/qbittorrent/port.sh &
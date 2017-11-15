#!/bin/bash
[ ! -d ${XDG_CONFIG_HOME}/qBittorrent ] && mkdir --parents ${XDG_CONFIG_HOME}/qBittorrent

if [ ! -f ${XDG_CONFIG_HOME}/qBittorrent/qBittorrent.conf ]; then
    cat << 'EOF' > ${XDG_CONFIG_HOME}/qBittorrent/qBittorrent.conf
[LegalNotice]
Accepted=true

[Preferences]
Connection\UPnP=false
Downloads\SavePath=/data/complete/
Downloads\TempPath=/data/incomplete/
Downloads\TempPathEnabled=true
WebUI\LocalHostAuth=false
WebUI\UseUPnP=false
EOF
fi

$(which qbittorrent-nox) \
    --webui-port=${QBITTORRENT_WEBUI_PORT}

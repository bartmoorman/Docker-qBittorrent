#!/bin/bash
echo ${OPENVPN_USERNAME} > /etc/openvpn/credentials.txt
echo ${OPENVPN_PASSWORD} >> /etc/openvpn/credentials.txt

if [ -f /etc/openvpn/openvpn.zip ] || [ -f /etc/openvpn/openvpn-strong.zip ]; then
    if [ -f /etc/openvpn/openvpn-strong.zip ]; then
      unzip -q -d /etc/openvpn /etc/openvpn/openvpn-strong.zip
    elif [ -f /etc/openvpn/openvpn.zip ]; then
      unzip -q -d /etc/openvpn /etc/openvpn/openvpn.zip
    fi

    rm --force /etc/openvpn/openvpn.zip /etc/openvpn/openvpn-strong.zip

    sed --in-place --regexp-extended \
    --expression 's/^(auth-user-pass)$/\1 credentials.txt/' \
    /etc/openvpn/*.ovpn
fi

exec $(which openvpn) \
    --config "/etc/openvpn/${OPENVPN_GATEWAY}.ovpn" \
    --route-up /etc/openvpn/route.sh \
    --ping-exit 60 \
    --ping 10 \
    --up /etc/qbittorrent/start.sh \
    --up-delay \
    --down /etc/qbittorrent/stop.sh \
    --down-pre \
    --setenv OPENVPN_GATEWAY ${OPENVPN_GATEWAY} \
    --setenv OPENVPN_LOCAL_NETWORK ${OPENVPN_LOCAL_NETWORK} \
    --setenv QBITTORRENT_WEBUI_PORT ${QBITTORRENT_WEBUI_PORT} \
    --setenv QBITTORRENT_MIN_PORT_HRS ${QBITTORRENT_MIN_PORT_HRS} \
    --setenv QBITTORRENT_MAX_PORT_HRS ${QBITTORRENT_MAX_PORT_HRS} \
    --setenv XDG_DATA_HOME ${XDG_DATA_HOME} \
    --setenv XDG_CONFIG_HOME ${XDG_CONFIG_HOME} \
    --script-security 2 \
    --cd /etc/openvpn \
    --log /var/log/openvpn.log

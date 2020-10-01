#!/bin/bash
# https://www.privateinternetaccess.com/pages/client-support/#eighth
# Temporarily remove Canada
# https://www.privateinternetaccess.com/helpdesk/news/posts/march-31-2020-port-forwarding-issues
# gateways=('CA Toronto' 'CA Montreal' 'CA Vancouver' 'DE Berlin' 'DE Frankfurt' 'France' 'Czech Republic' 'Spain' 'Romania' 'Israel')
gateways=('DE Berlin' 'DE Frankfurt' 'France' 'Czech Republic' 'Spain' 'Romania' 'Israel')

echo "${OPENVPN_USERNAME}" > credentials.txt
echo "${OPENVPN_PASSWORD}" >> credentials.txt

if [ -f openvpn.zip -o -f openvpn-strong.zip ]; then
    if [ -f openvpn-strong.zip ]; then
        unzip -q openvpn-strong.zip
    elif [ -f openvpn.zip ]; then
        unzip -q openvpn.zip
    fi

    rm --force openvpn.zip openvpn-strong.zip

    sed --in-place --regexp-extended \
    --expression 's/^(auth-user-pass)$/\1 credentials.txt/' \
    *.ovpn
fi

if [ "${OPENVPN_GATEWAY}" == 'Automatic' ]; then
    remotes=$(sed --regexp-extended --silent 's/^remote\s+(.*)\s+[0-9]+$/\1/p' "${gateways[@]/%/.ovpn}")

    while true; do
        selected=$(netselect ${remotes} | awk '{print $2}' | sed 's/\./\\\./g')

        if [ -n "${selected}" ]; then
            export OPENVPN_GATEWAY=$(egrep --files-with-matches "^remote\s+${selected}\s+[0-9]+$" "${gateways[@]/%/.ovpn}" | cut --delimiter . --fields 1)
            export OPENVPN_CAN_FORWARD=true
            break
        fi

        sleep $((sleep += 5))
    done
else
    for gateway in "${gateways[@]}"; do
        if [ "${gateway}" == "${OPENVPN_GATEWAY}" ]; then
            export OPENVPN_CAN_FORWARD=true
            break
        fi
    done
fi

exec $(which openvpn) \
    --config "${OPENVPN_GATEWAY}.ovpn" \
    --route-up route.sh \
    --ping-exit 60 \
    --ping 10 \
    --up /etc/qbittorrent/start.sh \
    --up-delay \
    --down /etc/qbittorrent/stop.sh \
    --down-pre \
    --setenv OPENVPN_LOCAL_NETWORK ${OPENVPN_LOCAL_NETWORK} \
    --setenv OPENVPN_CAN_FORWARD ${OPENVPN_CAN_FORWARD:-false} \
    --setenv QBITTORRENT_WEBUI_PORT ${QBITTORRENT_WEBUI_PORT} \
    --setenv QBITTORRENT_MIN_PORT_HRS ${QBITTORRENT_MIN_PORT_HRS} \
    --setenv QBITTORRENT_MAX_PORT_HRS ${QBITTORRENT_MAX_PORT_HRS} \
    --setenv XDG_DATA_HOME "${XDG_DATA_HOME}" \
    --setenv XDG_CONFIG_HOME "${XDG_CONFIG_HOME}" \
    --script-security 2 \
    --log /var/log/openvpn.log

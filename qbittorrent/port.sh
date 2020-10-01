#!/bin/bash
if [ ${OPENVPN_CAN_FORWARD} == true ]; then
    while true; do
        while ! curl --silent localhost:${QBITTORRENT_WEBUI_PORT} > /dev/null; do
            sleep $((sleepa += 1))
        done

        if [ -f /config/client_id.txt ]; then
            client_id=$(cat /config/client_id.txt)
        else
            client_id=$(head -100 /dev/urandom | md5sum | tr --delete ' -')
            echo ${client_id} > /config/client_id.txt
        fi

        mapfile -n 2 -t credentials < /etc/openvpn/credentials.txt
        local_ip=$(ip address show tun0 | egrep --only-matching 'inet\s*([0-9]{1,3}\.?){4}' | tr --delete 'a-z ')
        data="user=${credentials[0]}&pass=${credentials[1]}&client_id=${client_id}&local_ip=${local_ip}"

        while true; do
            port=$(curl --silent --location --data ${data} "https://www.privateinternetaccess.com/vpninfo/port_forward_assignment" | jq --raw-output '.port')

            if egrep --silent '^[0-9]+$' <<< ${port}; then
                curl --silent --data "json={\"listen_port\":${port}}" localhost:${QBITTORRENT_WEBUI_PORT}/command/setPreferences
                break
            fi

            sleep $((sleepb += 5))
        done

        min=$((60 * 60 * ${QBITTORRENT_MIN_PORT_HRS}))
        max=$((60 * 60 * ${QBITTORRENT_MAX_PORT_HRS}))
        sleep $((RANDOM % (${max} - ${min} + 1) + ${min}))
    done
fi

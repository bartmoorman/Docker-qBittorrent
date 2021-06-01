FROM bmoorman/ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive \
    TARGETPLATFORM

ENV PIA_USER="**username**" \
    PIA_PASS="**password**" \
    LOCAL_NETWORK="192.168.0.0/16" \
    QBITTORRENT_WEBUI_PORT="8080" \
    XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

WORKDIR /etc/openvpn

RUN echo 'deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu bionic main ' > /etc/apt/sources.list.d/qbittorrent.list \
 && echo 'deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu bionic main' >> /etc/apt/sources.list.d/qbittorrent.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D35164147CA69FC4 \
 && echo 'deb https://packagecloud.io/ookla/speedtest-cli/ubuntu/ bionic main' > /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && echo 'deb-src https://packagecloud.io/ookla/speedtest-cli/ubuntu/ bionic main' >> /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && curl --silent --location "https://packagecloud.io/ookla/speedtest-cli/gpgkey" | apt-key add \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    jq \
    openvpn \
    qbittorrent-nox \
    speedtest \
    unzip \
    wget \
 && wget --quiet --directory-prefix /usr/local/share/ca-certificates "https://raw.githubusercontent.com/pia-foss/manual-connections/master/ca.rsa.4096.crt" \
 && update-ca-certificates \
 && wget --quiet --directory-prefix /etc/openvpn "https://www.privateinternetaccess.com/openvpn/openvpn.zip" \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ${TARGETPLATFORM}/netselect /usr/local/bin/
COPY openvpn/ /etc/openvpn/
COPY qbittorrent/ /etc/qbittorrent/

VOLUME /config /data

EXPOSE ${QBITTORRENT_WEBUI_PORT}

CMD ["/etc/openvpn/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD curl --head --insecure --silent --show-error --fail "http://localhost:${QBITTORRENT_WEBUI_PORT}/" || exit 1

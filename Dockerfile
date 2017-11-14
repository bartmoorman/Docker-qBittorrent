FROM bmoorman/ubuntu

ENV OPENVPN_USERNAME="**username**" \
    OPENVPN_PASSWORD="**password**" \
    OPENVPN_GATEWAY="Netherlands" \
    OPENVPN_LOCAL_NETWORK="192.168.0.0/16" \
    QBITTORRENT_WEBUI_PORT="8080" \
    QBITTORRENT_MIN_PORT_HRS="4" \
    QBITTORRENT_MAX_PORT_HRS="8" \
    XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

ARG DEBIAN_FRONTEND="noninteractive"

RUN echo 'deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu xenial main ' > /etc/apt/sources.list.d/qbittorrent.list \
 && echo 'deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu xenial main' >> /etc/apt/sources.list.d/qbittorrent.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7CA69FC4 \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    curl \
    jq \
    openssh-client \
    openvpn \
    qbittorrent-nox \
    unrar \
    unzip \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /etc/openvpn/
#ADD https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip /etc/openvpn/

COPY openvpn/ /etc/openvpn/
COPY qbittorrent/ /etc/qbittorrent/

VOLUME /data /config

EXPOSE 8080

CMD ["/etc/openvpn/start.sh"]

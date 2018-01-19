FROM bmoorman/ubuntu

ENV OPENVPN_USERNAME="**username**" \
    OPENVPN_PASSWORD="**password**" \
    OPENVPN_GATEWAY="Automatic" \
    OPENVPN_LOCAL_NETWORK="192.168.0.0/16" \
    QBITTORRENT_WEBUI_PORT="8080" \
    QBITTORRENT_MIN_PORT_HRS="4" \
    QBITTORRENT_MAX_PORT_HRS="8" \
    XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

ARG DEBIAN_FRONTEND="noninteractive"

WORKDIR /etc/openvpn

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
    wget \
 && wget --quiet --directory-prefix /tmp "http://ftp.debian.org/debian/pool/main/n/netselect/netselect_0.3.ds1-28+b1_amd64.deb" \
 && dpkg --install /tmp/netselect_*_amd64.deb \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /etc/openvpn/
#ADD https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip /etc/openvpn/

COPY openvpn/ /etc/openvpn/
COPY qbittorrent/ /etc/qbittorrent/

VOLUME /config /data

EXPOSE 8080

CMD ["/etc/openvpn/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD curl --silent --location --fail http://localhost:8080/ > /dev/null || exit 1

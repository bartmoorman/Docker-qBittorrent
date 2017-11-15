FROM bmoorman/ubuntu

ENV QBITTORRENT_WEBUI_PORT="8080" \
    XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

ARG DEBIAN_FRONTEND="noninteractive"

RUN echo 'deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu xenial main ' > /etc/apt/sources.list.d/qbittorrent.list \
 && echo 'deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu xenial main' >> /etc/apt/sources.list.d/qbittorrent.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7CA69FC4 \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    curl \
    openssh-client \
    qbittorrent-nox \
    unrar \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY qbittorrent/ /etc/qbittorrent/

VOLUME /config /data

EXPOSE 8080

CMD ["/etc/qbittorrent/start.sh"]

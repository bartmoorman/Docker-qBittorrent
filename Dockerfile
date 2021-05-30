FROM bmoorman/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

ENV QBITTORRENT_WEBUI_PORT="8080" \
    XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

RUN echo 'deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main ' > /etc/apt/sources.list.d/qbittorrent.list \
 && echo 'deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main' >> /etc/apt/sources.list.d/qbittorrent.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D35164147CA69FC4 \
 && echo 'deb https://packagecloud.io/ookla/speedtest-cli/ubuntu/ focal main' > /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && echo 'deb-src https://packagecloud.io/ookla/speedtest-cli/ubuntu/ focal main' >> /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && curl --silent --location "https://packagecloud.io/ookla/speedtest-cli/gpgkey" | apt-key add \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    openssh-client \
    qbittorrent-nox \
    speedtest \
    unrar \
    unzip \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY qbittorrent/ /etc/qbittorrent/

VOLUME /config /data

EXPOSE ${QBITTORRENT_WEBUI_PORT}

CMD ["/etc/qbittorrent/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD curl --head --insecure --silent --show-error --fail "http://localhost:${QBITTORRENT_WEBUI_PORT}/" || exit 1

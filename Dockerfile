FROM alpine:edge

ARG BUILD_CORES

ENV UID=991 GID=991 \
    FLOOD_SECRET=supersecret \
    CONTEXT_PATH=/ \
    RTORRENT_SCGI=0

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    git" \
 && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    rtorrent \
    ca-certificates \
    curl \
    ncurses \
    libressl \
    gzip \
    zip \
    zlib \
    unrar \
    s6 \
    su-exec \
    python \
    nodejs \
    nodejs-npm \
 && cd /usr && git clone https://github.com/jfurrow/flood && cd flood \
 && npm install --production \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY config.js /usr/flood/
COPY s6.d /etc/s6.d
COPY run.sh /usr/bin/
COPY config.js /usr/flood/
COPY rtorrent.rc /home/torrent/.rtorrent.rc

RUN chmod +x /usr/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /flood-db /torrents

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end"

CMD ["run.sh"]

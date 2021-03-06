FROM alpine:3.12

ARG RTORRENT_VER=0.9.8
ARG LIBTORRENT_VER=0.13.8
ARG FLOOD_VER=4.3.1
ARG BUILD_CORES

ENV UID=991 GID=991 \
    FLOOD_SECRET=supersecret \
    CONTEXT_PATH=/ \
    RTORRENT_SCGI=0 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    SEED_PORT=44815

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
  && set -e -x \\
  &&  apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    git \
    libtool \
    automake \
    autoconf \
    wget \
    tar \
    xz \
    zlib-dev \
    cppunit-dev \
    libressl-dev \
    ncurses-dev \
    curl-dev \
    binutils \
    linux-headers \
 && apk add \
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
    python2 \
    nodejs \
    nodejs-npm \
    openjdk8-jre \
    java-jna-native \
 && cd /tmp && mkdir libtorrent rtorrent \
 && cd libtorrent && wget -qO- https://github.com/rakshasa/libtorrent/archive/v${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd ../rtorrent && wget -qO- https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/rtorrent-${RTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && git clone https://github.com/mirror/xmlrpc-c.git \
 && git clone https://github.com/Rudde/mktorrent.git \
 && cd /tmp/mktorrent && make -j ${NB_CORES} && make install \
 && cd /tmp/xmlrpc-c/stable && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/libtorrent && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install \
 && cd /tmp \
 && strip -s /usr/local/bin/rtorrent \
 && strip -s /usr/local/bin/mktorrent \
 && mkdir /usr/flood && cd /usr/flood && wget -qO- https://github.com/jesec/flood/archive/v${FLOOD_VER}.tar.gz | tar xz --strip 1 \
 && npm install && npm cache clean --force && npm run build \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY config.js /usr/flood/
COPY s6.d /etc/s6.d
COPY run.sh /usr/bin/
COPY config.js /usr/flood/
COPY rtorrent.rc /home/torrent/.rtorrent.rc

RUN chmod +x /usr/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /flood-db /torrents

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end" \
      rtorrent="rTorrent BiTorrent client v$RTORRENT_VER" \
      libtorrent="libtorrent v$LIBTORRENT_VER"

CMD ["run.sh"]

#!/bin/sh

sed -i -e "s|<FLOOD_SECRET>|$FLOOD_SECRET|g" /usr/flood/config.js
sed -i -e "s|<CONTEXT_PATH>|$CONTEXT_PATH|g" /usr/flood/config.js
sed -i -e "s|<SEED_PORT>|$SEED_PORT|g" /home/torrent/.rtorrent.rc

rm -f /torrents/rtorrent.lock
mv /usr/flood /usr/fix && mv /usr/fix /usr/flood # fix strange bug
chown -R $UID:$GID /home/torrent /torrents /tmp /flood-db /etc/s6.d

if [ ${RTORRENT_SCGI} -ne 0 ]; then
    sed -i -e 's|^scgi_local.*$|scgi_port = 0.0.0.0:'${RTORRENT_SCGI}'|' /home/torrent/.rtorrent.rc
    sed -i -e 's|socket: true,|socket: false,|' -e 's|port: 5000,|port: '${RTORRENT_SCGI}',|' /usr/flood/config.js
fi

exec su-exec $GID:$UID /bin/s6-svscan /etc/s6.d

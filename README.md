## rtorrent-flood

Based on wonderfall/dockerfiles/rtorrent-flood.

#### Main features
- Based on Alpine Linux.
- rTorrent and libtorrent are compiled from source.
- Provides by default a solid configuration.
- [Filebot](http://www.filebot.net/) is included, and creates symlinks in `/data/Media`.
- [Flood](https://github.com/jfurrow/flood), a modern web UI for rTorrent with a Node.js backend and React frontend.

#### Build-time variables
- **RTORRENT_VER** : rtorrent version
- **LIBTORRENT_VER** : libtorrent version
- **MEDIAINFO_VER** : libmediainfo version
- **FILEBOT_VER** : filebot version
- **BUILD_CORES** : number of cores used during build

#### Environment variables
- **UID** : user id (default : 991)
- **GID** : group id (defaut : 991)
- **FLOOD_SECRET** : flood secret key (defaut : mysupersecretkey) (CHANGE IT)
- **CONTEXT_PATH** : context path (base_URI) (default : /)
- **RTORRENT_SCGI** : SCGI port (default : 0 for use local socket)
- **PKG_CONFIG_PATH** : `/usr/local/lib/pkgconfig` (don't touch)

#### Ports
- **49184** (bind it).
- **3000** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)

#### Tags
- **latest** : latest versions of rTorrent/libtorrent.
- Use **$RTORRENT_VER-$LIBTORRENT_VER** to get specific versions of rTorrent/libtorrent.

#### Volumes
- **/data** : your downloaded torrents, session files, symlinks...
- **/flood-db** : Flood databases.

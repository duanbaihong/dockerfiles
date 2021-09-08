#!/usr/bin/dumb-init /bin/sh
. ${KOKO_INSTALL}/bin/init_koko

init_koko_config

exec ./koko -f conf/config.yml
# su-exec ${KOKO_USER}:${KOKO_USER} ./koko -f conf/config.yml

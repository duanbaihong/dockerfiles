#!/usr/bin/dumb-init /bin/sh


exec ${MYSLQ_EXPORTER_INSTALL}/mysqld_exporter/mysqld_exporter ${MYSQLD_EXPORTER_AGRS}

#!/usr/bin/dumb-init /bin/sh

. init_dnsmasq

initConfig

su-exec ${DNSMASQ_RUNUSER}:${DNSMASQ_RUNUSER} env HTTP_PASS=${HTTP_PASS} ${DNSMASQ_PREFIX}/sbin/webproc ${WEBPROC_USERARGS}\
    -c ${DNSMASQ_PREFIX}/etc/dnsmasq.conf\
    -c ${DNSMASQ_PREFIX}/etc/dnsmasq.hosts\
    -c ${DNSMASQ_PREFIX}/etc/resolv.conf\
    -- ${DNSMASQ_PREFIX}/sbin/dnsmasq\
    --conf-file=${DNSMASQ_PREFIX}/etc/dnsmasq.conf\
    --no-daemon

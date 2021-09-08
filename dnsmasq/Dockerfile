FROM alpine
MAINTAINER dbh888<duanbaihong@qq.com>
ARG DNSMASQ_VERSION=2.82
ENV DNSMASQ_PREFIX=/opt/dnsmasq \
    DNSMASQ_APPURL=http://www.thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz \
    DNSMASQ_WEBUI=https://github.com/jpillora/webproc/releases/download/v0.4.0/webproc_0.4.0_linux_amd64.gz \
    installDeps='gcc g++ make libcap-dev wget curl' \
    DNSMASQ_RUNUSER=dnsmasq \
    DNSMASQ_RUNUSERID=1000 \
    WEBPROC_USER=admin
# ADD ${DNSMASQ_APPURL} /tmp/
run sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add ${installDeps} su-exec libcap dumb-init \
    && cd /tmp/\
    && wget $DNSMASQ_APPURL \
    && tar xvf dnsmasq-${DNSMASQ_VERSION}.tar.gz \
    && cd dnsmasq-${DNSMASQ_VERSION} \
    && make && make install PREFIX=${DNSMASQ_PREFIX} \
    && mkdir ${DNSMASQ_PREFIX}/etc -p \
    && wget -c -t 0 $DNSMASQ_WEBUI -O - | gzip -d - >${DNSMASQ_PREFIX}/sbin/webproc \
    && chmod +x ${DNSMASQ_PREFIX}/sbin/webproc \
    && rm /tmp/* -rf \
    && apk del ${installDeps}

COPY entrypoint.sh init_dnsmasq /bin/
VOLUME ["${DNSMASQ_PREFIX}/etc"]
EXPOSE 53/tcp 53/udp 8080/tcp
WORKDIR ${DNSMASQ_PREFIX}
ENTRYPOINT ["/bin/entrypoint.sh"]
FROM alpine:3.13 
MAINTAINER dbh888<duanbaihong@qq.com>
ENV MYSLQ_EXPORTER_VERSION=0.13.0.linux-amd64 \
    MYSLQ_EXPORTER_INSTALL=/opt \
    PS1='[\u@\w]$' 
add entrypoint.sh   /bin/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add dumb-init bash \
    && mkdir $MYSLQ_EXPORTER_INSTALL -p \
    && wget -c https://pd.zwc365.com/seturl/https://github.com/prometheus/mysqld_exporter/releases/download/v0.13.0/mysqld_exporter-0.13.0.linux-amd64.tar.gz -O -|tar -xzv -C "${MYSLQ_EXPORTER_INSTALL}/" \
    && cd ${MYSLQ_EXPORTER_INSTALL} \
    && mv mysqld_exporter-${MYSLQ_EXPORTER_VERSION} mysqld_exporter \
    && rm -rf /var/cache/apk/*

EXPOSE 9104

ENTRYPOINT ["/bin/entrypoint.sh"]

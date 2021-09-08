FROM alpine
MAINTAINER dbh888<duanbaihong@qq.com>

ENV FRP_VERSION=0.21.1 \
    FRP_PREFIX=/opt/frp \
    FRP_TYPE=client \
    FRP_APPURL=https://github.com/fatedier/frp/releases/download/v0.24.1/frp_0.24.1_freebsd_amd64.tar.gz \
    FRP_RUNUSER=frp \
    FRP_RUNUSERID=1000 
COPY . /tmp/
run sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add su-exec libcap dumb-init \
    && cd /tmp/\
    # && tar xvf frp-${FRP_VERSION}.tar.xz \
    # && cd frp_${FRP_VERSION}_freebsd_amd64 \
    && mkdir ${FRP_PREFIX}/etc ${FRP_PREFIX}/bin ${FRP_PREFIX}/logs -p \
    && cp *.ini ${FRP_PREFIX}/ \
    && sed -i "s|^log_file = .logs/frps.log|# log_file = ${FRP_PREFIX}/logs/frps.log|g" ${FRP_PREFIX}/frps_full.ini  \
    && cp frps frpc  ${FRP_PREFIX}/bin \
    && rm /tmp/* -rf \
    && rm -rf /var/cache/apk/* 

COPY entrypoint.sh init_frp /bin/
VOLUME ["${FRP_PREFIX}/etc"]
EXPOSE 80 443 7500 7000-7001/udp
WORKDIR ${FRP_PREFIX}
ENTRYPOINT ["/bin/entrypoint.sh"]
FROM alpine:3.13
MAINTAINER dbh888<duanbaihong@qq.com>
ENV THANOS_VERSION=0.25.2 \
    THANOS_INSTALL=/a/apps/thanos \
    PS1='[\u@\w]$'

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash vim tzdata dumb-init\
    && mkdir -p ${THANOS_INSTALL} \
    && cd ${THANOS_INSTALL} \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi } \
    && funwget https://pd.zwc365.com/seturl/https://github.com/thanos-io/thanos/releases/download/v${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz \
    && mv ${THANOS_INSTALL}/thanos-${THANOS_VERSION}.linux-amd64 ${THANOS_INSTALL}/bin \
    && ln -sf ${THANOS_INSTALL}/bin/thanos /usr/bin/
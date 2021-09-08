FROM alpine:3.10.2
MAINTAINER dbh888 <duanbaihong@qq.com>
ARG KOKO_INSTALL=/opt/koko
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    VERSION=1.4.7 \
    CORE_HOST="http://jumpserver" \
    KOKO_USER="koko" \
    IP_DEVICE="" \
    EXT_PACKAGE="dumb-init su-exec mysql-client" \
    EXT_TMP_PACKAGE="" \
    KOKO_INSTALL=$KOKO_INSTALL \
    PATH=$KOKO_INSTALL:$PATH \
    JUMPSERVER_HTTP_PORT=8080 \
    PS1='[\u@\w]$'
    
COPY bin ${KOKO_INSTALL}
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add ${EXT_PACKAGE} ${EXT_TMP_PACKAGE} \
    && apk del ${EXT_TMP_PACKAGE} \
    && ln -sf /usr/bin/mysql ${KOKO_INSTALL}/mysql \
    && mkdir -p  ${KOKO_INSTALL}/conf

VOLUME ["${KOKO_INSTALL}/conf"]
WORKDIR ${KOKO_INSTALL}

EXPOSE 5000 2222

ENTRYPOINT ["bin/entrypoint.sh"]

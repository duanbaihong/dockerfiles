FROM alpine:3.10.2
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 VERSION=1.4.7 \
    CORE_HOST="" \
    JUMPSERVER_HTTP_PORT="8080" \
    IP_DEVICE="" \
    EXT_PACKAGE="python3 py3-pip dumb-init su-exec" \
    EXT_TMP_PACKAGE="make gcc g++ python3-dev"
WORKDIR /opt/coco
COPY coco entrypoint.sh init_coco /opt/coco/
# ADD https://github.com/jumpserver/coco/archive/${VERSION}.tar.gz /opt/coco
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    # && tar xvf ${VERSION}.tar.gz \
    # && rm -f coco-${VERSION}/entrypoint.sh \
    # && mv coco-${VERSION}/* . \
    # && rm -rf coco-${VERSION} ${VERSION}.tar.gz \
    && mkdir -p /root/.config/pip/ \
    && echo -e "[global]\nindex-url = http://mirrors.aliyun.com/pypi/simple\n[install]\ntrusted-host=mirrors.aliyun.com" >$HOME/.config/pip/pip.conf \
    && apk add --no-cache $(cat requirements/alpine_requirements.txt) ${EXT_PACKAGE} ${EXT_TMP_PACKAGE} \
    && pip3 install --upgrade pip \
    && pip3 install -r requirements/requirements.txt \
    && cp config_example.yml config.yml \
    && apk del ${EXT_TMP_PACKAGE} \
    && rm -rf ~/.cache/pip　\
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && mkdir -p /opt/coco/tmp

VOLUME ["/opt/coco/data","/opt/coco/logs"]

EXPOSE 5000 2222

ENTRYPOINT ["./entrypoint.sh"]

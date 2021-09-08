FROM alpine:latest
MAINTAINER dbh888 <duanbaihong@qq.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add gettext \
    && rm -rf /tmp/* /root/.cache 

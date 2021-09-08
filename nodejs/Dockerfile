FROM alpine:3.11
MAINTAINER dbh888<duanbaihong@qq.com>
ENV NODEJS_VERSION=1.18.0 \
    PS1='[\u@\w]$'

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add nodejs npm yarn \
    && npm config set registry http://registry.npm.taobao.org \
    && npm install -g cnpm pm2

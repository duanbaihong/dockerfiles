FROM anapsix/alpine-java:latest
ARG CANEL_PREFIX=/a/apps/canel-adapter
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV PATH=$PATH:/opt/jdk/bin \
    JAVA_HOME=/opt/jdk/ \
    CANEL_VERSION=1.1.5 \
    CANEL_PREFIX=${CANEL_PREFIX}/ \
    JVM_OPTS="" \
    CANEL_ARGS="" \
    PS1='[\u@\w]$' 

WORKDIR $CANEL_PREFIX

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash dumb-init \
    && mkdir -p ${CANEL_PREFIX} \
    && cd  ${CANEL_PREFIX} \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi } \
    && funwget https://github.com/alibaba/canal/releases/download/canal-${CANEL_VERSION}/canal.adapter-${CANEL_VERSION}.tar.gz 


ADD entrypoint.sh ${CANEL_PREFIX}/bin

EXPOSE  8089 11111 11110

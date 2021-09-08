FROM anapsix/alpine-java:latest
ARG ZOOKEEPER_PREFIX=/a/apps/zookeeper/
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV PATH=$PATH:/usr/local/bin:${ZOOKEEPER_PREFIX}bin/:/opt/jdk/bin \
    JAVA_HOME=/opt/jdk/ \
    ZOOKEEPER_VERSION=3.6.3 \
    ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX} \
    SERVER_JVMFLAGS="" \
    PS1='[\u@\w]$' 

ADD bin/ libs/ /usr/local/bin
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash dumb-init curl \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi } \
    && funwget https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && mkdir -p ${ZOOKEEPER_PREFIX} /opt/libs\
    && cp -rf apache-zookeeper-${ZOOKEEPER_VERSION}-bin/* ${ZOOKEEPER_PREFIX} \
    && rm -rf apache-zookeeper-${ZOOKEEPER_VERSION}-bin \
    && cd ${ZOOKEEPER_PREFIX} \
    && rm -rf LICENSE.txt NOTICE.txt README_packaging.md README.md \
    && mv /usr/local/bin/*.jar /opt/libs
WORKDIR ${ZOOKEEPER_PREFIX}

ENTRYPOINT ["/usr/local/bin/zookeeperStart.sh"]
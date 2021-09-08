FROM anapsix/alpine-java:latest
ARG LTS_PREFIX=/a/apps/lts
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV PATH=$PATH:/opt/jdk/bin \
    JAVA_HOME=/opt/jdk/ \
    LTS_PREFIX=${LTS_PREFIX}/ \
    JVMFLAGS="-Dfile.encoding=UTF-8" \
    PS1='[\u@\w]$' 

ADD ../lts.tar ${LTS_PREFIX}
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash dumb-init 
EXPOSE  8060 3502
WORKDIR ${LTS_PREFIX}
# ENTRYPOINT ["${LTS_PREFIX}/bin/lts-admin.sh","start"]


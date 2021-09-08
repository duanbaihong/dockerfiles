FROM anapsix/alpine-java:latest
ARG DUBBO_PREFIX=/a/apps/dubbo/dubbo-monitor/
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV PATH=$PATH:/opt/jdk/bin \
    JAVA_HOME=/opt/jdk \
    DUBBO_PREFIX=${DUBBO_PREFIX} \
    JVM_PARAM="" \
    PS1='[\u@\w]$' 

ADD entrypoint.sh ${DUBBO_PREFIX}
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash dumb-init \
    && cd ${DUBBO_PREFIX} \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi } \
    && funwget http://test2-auto-test.xiujiadian.com/files/dubbo-monitor.tar.gz \
    && mv ${DUBBO_PREFIX}entrypoint.sh /bin/ \
    && chmod +x /bin/entrypoint.sh;echo
EXPOSE  7070 8080
WORKDIR ${DUBBO_PREFIX}
ENTRYPOINT ["/bin/entrypoint.sh"]

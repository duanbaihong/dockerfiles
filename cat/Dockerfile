FROM tomcat:9.0.20-jre8-alpine
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV TOMCAT_INSTALL=/usr/local/tomcat \
    CAT_RUN_USER=cat

COPY cat.war $TOMCAT_INSTALL/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && sed -i 's|port="8080" protocol="HTTP/1.1"|port="9080" protocol="org.apache.coyote.http11.Http11AprProtocol"|g' $TOMCAT_INSTALL/conf/server.xml \
    && rm -rf $TOMCAT_INSTALL/webapps/* $TOMCAT_INSTALL/*.txt $TOMCAT_INSTALL/*.md $TOMCAT_INSTALL/LICENSE $TOMCAT_INSTALL/NOTICE $TOMCAT_INSTALL/RELEASE-NOTES \
    && adduser -D -h $TOMCAT_INSTALL ${CAT_RUN_USER} \
    && mv $TOMCAT_INSTALL/cat.war $TOMCAT_INSTALL/webapps/ \
    && mkdir /data/appdatas/cat/ -p \
    && chown -R $CAT_RUN_USER:$CAT_RUN_USER $TOMCAT_INSTALL /data

USER  $CAT_RUN_USER

VOLUME ["/data"]

EXPOSE 9080 2280


FROM alpine:3.10.2
MAINTAINER dbh888<duanbaihong@qq.com>

# ******************设置JAVA变量环境******************
ENV APP_NAME=jenkins \
    LANG=zh_CN.UTF-8 \
    GLIBC_VERSION=2.30-r0 \
    JENKINS_UC=https://updates.jenkins.io \
    JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental \
    JENKINS_VERSION=2.190.3 \
    JENKINS_RUNUSER=jenkins \
    JENKINS_RUNID=1000 \
    JENKINS_PREFIX=/jenkins \
    JENKINS_HTTPSPORT=8443 \
    JENKINS_HTTPPORT=8080 \
    JENKINS_LANAGUAGE=zh \
    JENKINS_WARDIR=/opt/jenkins \
    JENKINS_HOME=/opt/jenkins/jenkins_home \
    JENKINS_EXTRA_LIB=/opt/jenkins/lib \
    JAVA_HOME=/opt/jdk \
    CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar \
    JAVA_OPTS="" \
    JENKINS_BASEAPK='bash dumb-init su-exec' \
    APK_DEPENDENCY='openssh-client nss git docker-cli ttf-dejavu fontconfig sshpass curl ansible nodejs npm yarn'

ADD jdk-8u231-linux-x64.tar.gz entrypoint.sh init_jenkins health_check.py /opt/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add $JENKINS_BASEAPK \
    && mkdir ${JENKINS_HOME} ${JENKINS_EXTRA_LIB} -p \
    && mv /opt/entrypoint.sh /bin/ \
    && mv /opt/init_jenkins /bin/ \
    && ln -sf /opt/jdk1.8.0_231 /opt/jdk \
    && ln -sf /opt/jdk/bin/* /bin/ \
    && rm -rf ${JAVA_HOME}/*src.zip /var/cache/apk/* \
      ${JAVA_HOME}/*.txt \
      ${JAVA_HOME}/*src.zip \
      ${JAVA_HOME}/man \
      ${JAVA_HOME}/lib/missioncontrol \
      ${JAVA_HOME}/lib/visualvm \
      ${JAVA_HOME}/lib/*javafx* \
      ${JAVA_HOME}/lib/plugin.jar \
      ${JAVA_HOME}/lib/ext/jfxrt.jar \
      ${JAVA_HOME}/jre/*.txt \
      ${JAVA_HOME}/jre/lib/plugin.jar \
      ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
      ${JAVA_HOME}/jre/bin/javaws \
      ${JAVA_HOME}/jre/lib/javaws.jar \
      ${JAVA_HOME}/jre/lib/desktop \
      ${JAVA_HOME}/jre/plugin \
      ${JAVA_HOME}/jre/lib/deploy* \
      ${JAVA_HOME}/jre/lib/*javafx* \
      ${JAVA_HOME}/jre/lib/*jfx* \
      ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
      ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
      ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
      ${JAVA_HOME}/jre/lib/amd64/libglass.so \
      ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
      ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
      ${JAVA_HOME}/jre/lib/amd64/libjfx*.so \
      ${JAVA_HOME}/jre/bin/jjs \
      ${JAVA_HOME}/jre/bin/keytool \
      ${JAVA_HOME}/jre/bin/orbd \
      ${JAVA_HOME}/jre/bin/pack200 \
      ${JAVA_HOME}/jre/bin/policytool \
      ${JAVA_HOME}/jre/bin/rmid \
      ${JAVA_HOME}/jre/bin/rmiregistry \
      ${JAVA_HOME}/jre/bin/servertool \
      ${JAVA_HOME}/jre/bin/tnameserv \
      ${JAVA_HOME}/jre/bin/unpack200 \
      ${JAVA_HOME}/jre/lib/jfr.jar \
      ${JAVA_HOME}/jre/lib/jfr \
      ${JAVA_HOME}/jre/lib/oblique-fonts

WORKDIR ${JENKINS_HOME} 

EXPOSE  ${JENKINS_HTTPSPORT} ${JENKINS_HTTPPORT}

ENTRYPOINT ["/bin/entrypoint.sh"]
FROM alpine:3.8
MAINTAINER dbh888<duanbaihong@qq.com>

# ******************设置JAVA变量环境******************
ENV APP_NAME=jenkins \
    JAVA_OPTS="" \
    JENKINS_UC=https://updates.jenkins.io \
    JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental \
    JENKINS_VERSION=2.164.1 \
    JENKINS_RUNUSER=jenkins \
    JENKINS_RUNID=1000 \
    JENKINS_PREFIX=/jenkins \
    JENKINS_HTTPSPORT=8443 \
    JENKINS_HTTPPORT=8080 \
    JENKINS_LANAGUAGE=zh \
    JENKINS_HOME=/opt/jenkins/jenkins_home \
    JENKINS_EXTRA_LIB=/opt/jenkins/lib \
    APK_DEPENDENCY='openjdk8 bash openssh-client dumb-init su-exec nss ttf-dejavu fontconfig git docker sshpass curl'

ADD https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/${JENKINS_VERSION}/${APP_NAME}.war entrypoint.sh init_jenkins health_check.py unarchive.py /bin/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk --no-cache add ${APK_DEPENDENCY}\
    && mkdir ${JENKINS_HOME} -p \
    && rm -f /usr/bin/docker-containerd \
    /usr/bin/docker-containerd-ctr \
    /usr/bin/docker-containerd-shim \
    /usr/bin/docker-init \
    /usr/bin/docker-proxy \
    /usr/bin/docker-runc \
    /usr/bin/dockerd \
    && echo 'JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk' >>/etc/profile \
    && echo 'CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >>/etc/profile \
    && echo 'PATH=$JAVA_HOME/bin:$PATH ' >>/etc/profile \
    && sed -i 's|3.8|3.4|g' /etc/apk/repositories;apk add ansible \
    && sed -i 's|3.4|3.9|g' /etc/apk/repositories;apk add nodejs npm \
    && npm install -g yarn \
    && rm /tmp/* -rf 

WORKDIR ${JENKINS_HOME}

EXPOSE  ${JENKINS_HTTPSPORT} ${JENKINS_HTTPPORT} 5000

ENTRYPOINT ["/bin/entrypoint.sh"]

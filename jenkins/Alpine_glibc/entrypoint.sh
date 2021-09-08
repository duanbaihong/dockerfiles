#!/usr/bin/dumb-init /bin/sh

. /bin/init_jenkins
formatOutput title

if [ ! -f "${JENKINS_WARDIR}/jenkins.war" ]; then
    formatOutput "The jenkins.war package was not found, It will be downloaded automatically..."
    printOK $?
    wget http://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war -P ${JENKINS_WARDIR}
fi
id ${JENKINS_RUNUSER} &>/dev/null 2>&1
if [  $? -ne 0 ]; then
    init_config
fi
formatOutput "Begin Start App [\033[31m${APP_NAME}\033[0m],Listen Port [\033[31m${JENKINS_HTTPPORT},${JENKINS_HTTPSPORT}\033[0m]...."
printOK $?
PATH=$JAVA_HOME/bin:$PATH
su-exec ${JENKINS_RUNUSER}:${JENKINS_RUNUSER} java \
    -Duser.language=zh \
    -Duser.timezone=Asia/Shanghai \
    -Dsun.jnu.encoding=UTF-8 \
    -Dfile.encoding=UTF-8 ${JAVA_OPTS} \
    -jar ${JENKINS_WARDIR}/${APP_NAME}.war \
    --prefix=${JENKINS_PREFIX} \
    --httpPort=${JENKINS_HTTPPORT} \
    --httpsPort=${JENKINS_HTTPSPORT} \
    --commonLibFolder=${JENKINS_EXTRA_LIB}

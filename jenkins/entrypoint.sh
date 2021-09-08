#!/usr/bin/dumb-init /bin/sh

. /bin/init_jenkins
. /etc/profile
formatOutput title


id ${JENKINS_RUNUSER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    formatOutput "Initial ${APP_NAME} User [\033[31m${JENKINS_RUNUSER}\033[0m]"
    #statements
    adduser -D -h ${JENKINS_HOME} -s /sbin/nologin -u ${JENKINS_RUNID} ${JENKINS_RUNUSER} >& /dev/null;
    printOK $?
    formatOutput "Repair work directory [${JENKINS_HOME}] permissions...."
    chown ${JENKINS_RUNUSER}.${JENKINS_RUNUSER} /opt/jenkins /bin/${APP_NAME}.war  -R
    printOK $?
    
    init_config
fi
formatOutput "Begin Start App [\033[31m${APP_NAME}\033[0m],Listen Port [\033[31m${JENKINS_HTTPPORT},${JENKINS_HTTPSPORT}\033[0m]...."
printOK $?
su-exec ${JENKINS_RUNUSER}:${JENKINS_RUNUSER} java \
    -Duser.language=${JENKINS_LANAGUAGE} \
    -Duser.timezone=Asia/Shanghai \
    -Dsun.jnu.encoding=UTF-8 \
    -Dfile.encoding=UTF-8 ${JAVA_OPTS} \
    -jar /bin/${APP_NAME}.war \
    --prefix=${JENKINS_PREFIX} \
    --httpPort=${JENKINS_HTTPPORT} \
    --httpsPort=${JENKINS_HTTPSPORT} \
    --commonLibFolder=${JENKINS_EXTRA_LIB}

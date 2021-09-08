#!/bin/bash

. init_format

S_JVM_PARAM=${JVM_PARAM//"_jvm_param_blank_"/" "}
S_JVM_MEN_PARAM=${JVM_MEN//"_jvm_param_blank_"/" "}

#jdk9 default use G1GC
JVM_OPTS="-XX:+UseG1GC"
JVM_OPTS="-XX:+CMSScavengeBeforeRemark -XX:+UseConcMarkSweepGC -XX:CMSMaxAbortablePrecleanTime=5000 -XX:+CMSClassUnloadingEnabled -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly"
JVM_OPTS="${JVM_OPTS} -verbose:gc -Xloggc:${LOG_PATH}/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime "
JVM_OPTS="${JVM_OPTS} -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.server.exceptionTrace=true"
JVM_OPTS="${JVM_OPTS} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${LOG_PATH}/java.hprof"
JVM_OPTS="${JVM_OPTS} -XX:+UseCompressedOops"
JVM_OPTS="${JVM_OPTS} -Djava.awt.headless=true"
JVM_OPTS="${JVM_OPTS} -Dsun.net.client.defaultConnectTimeout=10000"
JVM_OPTS="${JVM_OPTS} -Dsun.net.client.defaultReadTimeout=30000"
JVM_OPTS="${JVM_OPTS} -Dserver.port=${PORT}"
JVM_OPTS="${JVM_OPTS} -Dspring.profiles.active=${PROFILES_ACTIVE}"
JVM_OPTS="${JVM_OPTS} -DLOG_PATH=${LOG_PATH}"
JVM_OPTS="${JVM_OPTS} -DLOG_NAME=${APP_NAME}"

if [[ -n "$S_JVM_PARAM" ]] && [[ "null" != "$S_JVM_PARAM" ]]; then
    JVM_OPTS="${JVM_OPTS} ${S_JVM_PARAM}"
fi

if [[ -n "$S_JVM_MEN_PARAM" ]] && [[ "null" != "$S_JVM_MEN_PARAM" ]]; then
    JVM_OPTS="${JVM_OPTS} ${S_JVM_MEN_PARAM}"
elif [[ "$RUN_MODE" =~ "prod" ]] ; then
    # jdk8 宸茬粡涓嶉渶瑕� -XX:PermSize=128m 鍙傛暟
    JVM_OPTS="${JVM_OPTS} -server -Xms512m -Xmx1024m -XX:NewSize=128m"
elif [[ "$RUN_MODE" =~ "test" ]] ; then
    JVM_OPTS="${JVM_OPTS} -server -Xms128m -Xmx256m -XX:NewSize=32m"
else
    JVM_OPTS="${JVM_OPTS} -server -Xms128m -Xmx256m -XX:NewSize=32m"
fi

if [[ "$RUN_MODE" =~ "test" ]] && [[ -n "$REMOTE_PORT" ]] && [[ "null" != "$REMOTE_PORT" ]]; then
     JVM_OPTS="${JVM_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${REMOTE_PORT}"
fi
formatOutput title
formatOutput "Begin Start App [\033[31m${APP_NAME}\033[0m],Enveriment is [\033[31m${RUN_MODE}\033[0m],Listen Port [\033[31m${PORT}\033[0m]...."
printOK $?
# trap "curl -s 127.0.0.1:${PORT}/app/shutdown 2>/dev/null 2>&1" SIGTERM
exec java ${JVM_OPTS} -jar /${APP_NAME}.jar
# currentPID=$!
wait $currentPID
formatOutput "\033[31mStoped App [${APP_NAME}]....\033[0m"
printOK $?
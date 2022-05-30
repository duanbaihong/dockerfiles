#!/usr/bin/dumb-init /bin/bash

LOG_FILE="${LOG_FILE:-/dev/stdout}"
JAVA_OPTS="${JAVA_OPTS:- -XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=80.0 \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha}"
JAR_PATH="${SKYWALKING_PREFIX}/webapp"

_RUNJAVA=${JAVA_HOME}/bin/java
[ -z "$JAVA_HOME" ] && _RUNJAVA=java

exec $_RUNJAVA ${JAVA_OPTS} -DLOG_FILE=${LOG_FILE} -jar ${JAR_PATH}/skywalking-webapp.jar \
    --spring.config.location=${JAR_PATH}/webapp.yml 
        

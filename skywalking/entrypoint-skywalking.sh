#!/usr/bin/dumb-init /bin/bash
OAP_LOG_DIR="${OAP_LOG_DIR:-${SKYWALKING_PREFIX}/logs}"
JAVA_OPTS="${JAVA_OPTS:- -XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=80.0 \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha}"

# if [ ! -d "${OAP_LOG_DIR}" ]; then
#     mkdir -p "${OAP_LOG_DIR}"
# fi

_RUNJAVA=${JAVA_HOME}/bin/java
[ -z "$JAVA_HOME" ] && _RUNJAVA=java

CLASSPATH="$SKYWALKING_PREFIX/config:$CLASSPATH"
for i in "$SKYWALKING_PREFIX"/oap-libs/*.jar
do
    CLASSPATH="$i:$CLASSPATH"
done

# OAP_OPTIONS=" -Doap.logDir=${OAP_LOG_DIR}"

exec $_RUNJAVA ${JAVA_OPTS} ${OAP_OPTIONS} -classpath $CLASSPATH org.apache.skywalking.oap.server.starter.OAPServerStartUp 


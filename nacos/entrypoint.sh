#!/usr/bin/dumb-init /bin/bash

if [[ $CLUSTER_TYPE == "CLUSTER" ]] ; then
    /bin/peer-finder -on-start=/bin/on-start.sh -on-change=/bin/on-change.sh -service=${SERVICE_NAME} || exit &
fi
java -server ${JVM_OPTS} \
-XX:MetaspaceSize=128m \
-XX:MaxMetaspaceSize=320m \
-XX:-OmitStackTraceInFastThrow \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=${NACOS_PREFIX}/nacos/logs/java_heapdump.hprof \
-XX:-UseLargePages \
-Dnacos.home=${NACOS_PREFIX}/nacos \
-jar ${NACOS_PREFIX}/nacos/target/nacos-server.jar \
--spring.config.additional-location=file:${NACOS_PREFIX}/nacos/conf/ \
--logging.config=${NACOS_PREFIX}/nacos/conf/nacos-logback.xml \
--server.max-http-header-size=524288 \
nacos.nacos
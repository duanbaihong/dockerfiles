#!/usr/bin/dumb-init /bin/bash

java -server \
-XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=90.0 \
-XX:MetaspaceSize=128m \
-XX:MaxMetaspaceSize=320m \
-XX:+UseConcMarkSweepGC \
-XX:+UseCMSCompactAtFullCollection \
-XX:CMSInitiatingOccupancyFraction=70 \
-XX:+CMSParallelRemarkEnabled \
-XX:SoftRefLRUPolicyMSPerMB=0 \
-XX:+CMSClassUnloadingEnabled \
-XX:SurvivorRatio=8 \
-XX:-UseParNewGC \
-verbose:gc \
-Xloggc:/dev/shm/rmq_srv_gc_%p_%t.log \
-XX:+PrintGCDetails \
-XX:+UseGCLogFileRotation \
-XX:NumberOfGCLogFiles=5 \
-XX:GCLogFileSize=30m \
-XX:-OmitStackTraceInFastThrow \
-XX:-UseLargePages \
${JVM_OPTS} \
-Djava.ext.dirs=${JAVA_HOME}/jre/lib/ext:${ROCKETMQ_PREFIX}/lib:${JAVA_HOME}/lib/ext \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha \
-cp .:${ROCKETMQ_PREFIX}/conf \
org.apache.rocketmq.namesrv.NamesrvStartup \
-c ${ROCKETMQ_PREFIX}/conf/namesrv.conf
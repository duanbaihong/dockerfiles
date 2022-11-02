#!/usr/bin/dumb-init /bin/bash

java -server \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shanghai \
-Djava.ext.dirs=${JAVA_HOME}/jre/lib/ext:${ROCKETMQ_PREFIX}/lib:${JAVA_HOME}/lib/ext \
${JVM_OPTS} \
-XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=70.0 \
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
-XX:+PrintGCDetails \
-XX:+UseGCLogFileRotation \
-XX:NumberOfGCLogFiles=5 \
-XX:GCLogFileSize=30m \
-XX:-OmitStackTraceInFastThrow \
-XX:-UseLargePages \
-cp .:${ROCKETMQ_PREFIX}/conf \
org.apache.rocketmq.namesrv.NamesrvStartup \
-c ${ROCKETMQ_PREFIX}/conf/namesrv.conf

#!/usr/bin/dumb-init /bin/bash
for file in  `ls ${ROCKETMQ_PREFIX}/template/*`;  
do 
    envsubst < $file >${ROCKETMQ_PREFIX}/conf/${file##*/} 
done

java -server \
-XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=70.0 \
-XX:G1HeapRegionSize=16m \
-XX:G1ReservePercent=25 \
-XX:InitiatingHeapOccupancyPercent=30 \
-verbose:gc \
-XX:SoftRefLRUPolicyMSPerMB=0 \
-XX:+PrintGCDetails \
-XX:+PrintGCDateStamps \
-XX:+PrintGCApplicationStoppedTime \
-XX:+PrintAdaptiveSizePolicy \
-XX:+UseGCLogFileRotation \
-XX:NumberOfGCLogFiles=5 \
-XX:GCLogFileSize=30m \
-XX:-OmitStackTraceInFastThrow \
-XX:+AlwaysPreTouch \
-XX:-UseLargePages \
-XX:-UseBiasedLocking \
${JVM_OPTS} \
-Djava.ext.dirs=${JAVA_HOME}/jre/lib/ext:${ROCKETMQ_PREFIX}/lib:${JAVA_HOME}/lib/ext \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha \
-cp .:${ROCKETMQ_PREFIX}/conf \
org.apache.rocketmq.broker.BrokerStartup \
-c ${ROCKETMQ_PREFIX}/conf/broker.conf

#!/usr/bin/dumb-init /bin/bash

java -XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=90.0 \
${JVM_PARAM} \
-jar ${DUBBO_PREFIX}/dubbo-admin-0.0.1-SNAPSHOT.jar 


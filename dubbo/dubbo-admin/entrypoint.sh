#!/usr/bin/dumb-init /bin/bash



java -XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=75.0 \
${JVM_PARAM} \
-jar ${DUBBO_PREFIX}/dubbo-admin-${DUBBO_VERSION}.jar 


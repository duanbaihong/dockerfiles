#!/usr/bin/dumb-init /bin/bash

java ${JVM_OPTS} \
-XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=90.0 \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha \
-Drocketmq.config.loginRequired=${ROCKETMQ_AUTH:-true} \
-Drocketmq.config.namesrvAddrs="${ROCKETMQ_NAMESRV:-127.0.0.1:9876}" \
-jar ${ROCKETMQ_CONSOLE_PREFIX}/rocketmq-dashboard.jar \
${ROCKETMQ_ARGS}
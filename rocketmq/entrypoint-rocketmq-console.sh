#!/usr/bin/dumb-init /bin/bash

java ${JVM_OPTS} \
-XshowSettings:vm \
-XX:+UseContainerSupport \
-XX:MaxRAMPercentage=90.0 \
-Dfile.encoding=utf-8 \
-Duser.timezone=Asia/Shangha \
-jar ${ROCKETMQ_CONSOLE_PREFIX}/rocketmq-console-ng-2.0.0.jar \
--rocketmq.config.loginRequired=${ROCKETMQ_AUTH:-true} \
--rocketmq.config.namesrvAddr="${ROCKETMQ_NAMESRV:-127.0.0.1:9876}" \
${ROCKETMQ_ARGS}
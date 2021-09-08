#!/usr/bin/dumb-init /bin/bash
JAVA_HOME=/opt/jdk
PATH=$PATH:/opt/jdk/bin
exec ${DUBBO_PREFIX}/bin/start.sh


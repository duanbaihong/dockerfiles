#!/usr/bin/dumb-init /bin/sh
# 
# env 变量，请传入下面参数，也可以不传！
#
ulimit -n 65535
. /bin/init_nginx
# 创建用户
id ${NGINX_USER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    formatOutput title
    initConfig
    #statements
    adduser -D -H -s /sbin/nologin -u ${NGINX_USERID} ${NGINX_USER} >& /dev/null;
    formatOutput "Repair user [\033[031m${NGINX_USER}\033[0m] directory permissions...."
    chown ${NGINX_USER}.${NGINX_USER} ${NGINX_PREFIX}  -R
    printOK $?
fi
formatOutput title
formatOutput "Start the Crond service to cut nginx logs....."
crond
printOK $?
if [ "${ENABLE_CONSUL_TEMPLATE}" == "true" ]; then
    formatOutput "Start the daemons of the 'consul-template' synchronization configuration...."
    /bin/consul-template -config ${NGINX_PREFIX}/conf/consul-template.cnf &
    printOK $?
fi

formatOutput "Begin startup nginx app for user [\033[31m${NGINX_USER}\033[0m]....."
printOK $?
exec ${NGINX_PREFIX}/sbin/nginx -c ${NGINX_PREFIX}/conf/nginx.conf  -g 'daemon off;' 

#!/usr/bin/dumb-init /bin/sh
# 
# env 变量，请传入下面参数，也可以不传！
#
PATH=${MYSQL_PREFIX}/bin:$PATH
ulimit -n 65535
. /bin/init_mysql
# 创建用户
id ${MYSQL_USER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    formatOutput title
    #statements
    adduser -D -H -s /sbin/nologin -u ${MYSQL_USERID} ${MYSQL_USER} >& /dev/null;
    formatOutput "Repair MySQL user directory permissions...."
    chown ${MYSQL_USER}.${MYSQL_USER} ${MYSQL_PREFIX}  -R
    printOK $?
    initConfig
fi
formatOutput title
formatOutput "Start the Crond service to cut MySQL logs....."
crond
printOK $?
formatOutput "Begin startup MySQL ${MYSQL_VERSION} for user [\033[31m${MYSQL_USER}\033[0m]....."
printOK $?
exec mysqld  --defaults-file=${MYSQL_PREFIX}/etc/mysqld.cnf \
    --user=${MYSQL_USER} \
    --datadir=${MYSQL_PREFIX}/data \
    --pid-file=${MYSQL_PREFIX}/run/mysql.pid \
    --slow-query-log-file=${MYSQL_PREFIX}/logs/slowquery.log 

    # --log-error=${MYSQL_PREFIX}/logs/mysqld.log

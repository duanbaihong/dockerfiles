#!/usr/bin/dumb-init /bin/sh
# 
# env 变量，请传入下面参数，也可以不传！
#
ulimit -n 65535
. /bin/init_php
# 创建用户
# /usr/bin/setcap "cap_net_bind_service=+ep" /usr/bin/php-fpm
setcap "cap_net_bind_service=+ep" /usr/sbin/php-fpm7

init_php_config

formatOutput "Begin startup php-fpm app for user [\033[31m${PHP_USER}\033[0m]....."
printOK $?
exec /usr/sbin/php-fpm7
#!/usr/bin/dumb-init /bin/sh

# 适用主从同步架构基于accesslog同步
# env 变量，请传入下面参数，也可以不传！
#
# LDAP_ROOT_DOMAIN=monitor 域名要，例如www.baidu.com 的 www
# LDAP_DOMAIN="iwubida.com" 域名
# LDAP_DEBUG=256  日志级别
# LDAP_DATA_DIR=/opt/ldap/data 数据目录
# LDAP_RUN_USER=ldap  运行用户
# LDAP_SSL=True 是否支持ssl
# LDAP_ROOT_PASSWORD=duanbai DB 密码 用户默认为root
# LDAP_ADMIN_USER=admin 管理用户名 例：Manager
# LDAP_ADMIN_PASSWORD=duanbai 管理用户的密码
# LDAP_SYNC_USER=syncuser 同步用户
# LDAP_SYNC_USERPASS=syncuser123 同步用户的密码
# LDAP_SYNC_SSL=True 同步是否启用SSL
# LDAP_SYNC_PORT=389 主从同步的MASTER 端口
# LDAP_CONF_DIR=/etc/ldap 配置文件目录
# LDAP_MASTER="Master" 是否是主，还是从选择Master,Slave

if [ "$1" = "bash" ]; then
  exec bash
fi

ulimit -n 65535
. init_openldap

if [ ! -d "${LDAP_CONF_DIR}/slapd.d/cn=config" ]; then
  help
  init_config
fi
formatOutput "title" 
# 正试启动应用
formatOutput "Starting \033[32mSlapd\033[0m Service...."
printOK $?
exec ${LDAP_INSTALL_PREFIX}/libexec/slapd -d $LDAP_DEBUG -F ${LDAP_CONF_DIR}/slapd.d -u ${LDAP_RUN_USER} -g ${LDAP_RUN_USER} -h "ldap:/// ldaps:/// ldapi:///"

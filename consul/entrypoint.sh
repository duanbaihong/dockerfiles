#!/usr/bin/dumb-init /bin/sh
# 
# env 变量，请传入下面参数，也可以不传！
#
ulimit -n 65535
. /bin/init_consul
# 创建用户
if [ ! -f "${CONSUL_CONFIG_DIR}/consul.json" ]; then
  formatOutput title
  formatOutput "Initial consul configuration file to [\033[31m${CONSUL_CONFIG_DIR}/consul.json\033[0m] ..."
  printOK $?
  id "${CONSUL_USER}" 2>/dev/null
  if [ $? -ne 0 ]; then
     formatOutput "Add Consul run user [\033[31m${CONSUL_USER}\033[0m]....."
     adduser -H -s /sbin/nologin -D ${CONSUL_USER} 2>/dev/null
     printOK $?
  fi
  # 生成配置文件目录、数据运行目录、TLS证书目录
  if [ ! -d "${CONSUL_CONFIG_DIR}/config" ]; then
    formatOutput "Generate configuration file directory, data run directory, TLS certificate directory....."
    mkdir -p ${CONSUL_CONFIG_DIR}/data ${CONSUL_CONFIG_DIR}/config ${CONSUL_CONFIG_DIR}/run ${CONSUL_CONFIG_DIR}/logs
    printOK $?
  fi
  initConfig
  if [ "$(stat -c %u ${CONSUL_CONFIG_DIR})" != "$(id -u ${CONSUL_USER})" ] ||
    [ "$(stat -c %u ${CONSUL_CONFIG_DIR}/data)" != "$(id -u ${CONSUL_USER})" ] ||
    [ "$(stat -c %u ${CONSUL_CONFIG_DIR}/consul.json)" != "$(id -u ${CONSUL_USER})" ]; then
      formatOutput "Fix directory permisions....."
      chown ${CONSUL_USER}:${CONSUL_USER} ${CONSUL_CONFIG_DIR} -R
      printOK $?
  fi
fi
# /usr/bin/setcap "cap_net_bind_service=+ep" /usr/bin/consul
setcap "cap_net_bind_service=+ep" /bin/consul
# trap 'kill -INT `cat ${CONSUL_CONFIG_DIR}/run/consul.pid`' SIGTERM
# /usr/bin/su-exec ${CONSUL_USER}:${CONSUL_USER} 
formatOutput title
formatOutput "Begin startup consul app for user [\033[31m${CONSUL_USER}\033[0m]....."
printOK $?
su-exec ${CONSUL_USER}:${CONSUL_USER} /bin/consul agent -config-file=${CONSUL_CONFIG_DIR}/consul.json -config-dir=${CONSUL_CONFIG_DIR}/config -pid-file=${CONSUL_CONFIG_DIR}/run/consul.pid -log-file=${CONSUL_CONFIG_DIR}/logs/consol.log
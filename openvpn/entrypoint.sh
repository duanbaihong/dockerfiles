#!/bin/sh
# 
# env 变量，请传入下面参数，也可以不传！
#
ulimit -n 65535
. /bin/init_openvpn
# 创建用户
if [ ! -f "${OPENVPN_PREFIX}/etc/certs/ca/ca.crt" ] \
    || [ ! -f "${OPENVPN_PREFIX}/etc/certs/server/server.crt" ] \
    || [ ! -f "${OPENVPN_PREFIX}/etc/certs/server/server.key" ] \
    || [ ! -f "${OPENVPN_PREFIX}/etc/certs/ca/dhparam.pem" ];then 
    mkdir ${OPENVPN_PREFIX}/etc/certs/ca \
    ${OPENVPN_PREFIX}/etc/certs/server \
    ${OPENVPN_PREFIX}/etc/certs/client \
    CreatCerts
fi
if [ "${OPENVPN_PLUGINTYPE}" != "c" ]; then
    init_iptables
fi
if [ ! -f "${OPENVPN_PREFIX}/etc/config.yaml" ]; then
   cp ${OPENVPN_PREFIX}/example/config.yaml ${OPENVPN_PREFIX}/etc/config.yaml -rf
fi
if [ ! -f "/etc/sysctl.d/openvpn.conf" ]; then
    init_kernel
fi
if [ ! -f "${OPENVPN_PREFIX}/etc/userpsw-file" ]; then
    echo "admin 123456" >${OPENVPN_PREFIX}/etc/userpsw-file
fi
if [ ! -f "${OPENVPN_PREFIX}/etc/server.conf" ]; then
   init_config
fi

if [ ! -d "${OPENVPN_PREFIX}/etc/ccd" ]; then
   mkdir ${OPENVPN_PREFIX}/etc/ccd -p
fi
id ${OPENVPN_USER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    #statements
    adduser -D -H -s /sbin/nologin -u ${OPENVPN_USERID} ${OPENVPN_USER} >& /dev/null;
    formatOutput "Repair user directory permissions...."
    chown ${OPENVPN_USER}.${OPENVPN_USER} ${OPENVPN_PREFIX}/etc ${OPENVPN_PREFIX}/run ${OPENVPN_PREFIX}/sbin ${OPENVPN_PREFIX}/logs -R
    printOK $?
    echo "${OPENVPN_USER}            ALL=(ALL)                NOPASSWD:/sbin/iptables" >>/etc/sudoers 
fi
formatOutput title
formatOutput "Begin startup openvpn app for user [\033[31m${OPENVPN_USER}\033[0m]....."
printOK $?
exec ${OPENVPN_PREFIX}/sbin/openvpn --config ${OPENVPN_PREFIX}/etc/server.conf --writepid ${OPENVPN_PREFIX}/run/openvpn.pid

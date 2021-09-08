#!/usr/bin/dumb-init /bin/sh
. init_frp

formatOutput title
id ${FRP_RUNUSER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    #statements
    formatOutput "Create FRP Running User [${FRP_RUNUSER}]...."
    adduser -D -H -s /sbin/nologin -u ${FRP_RUNUSERID} ${FRP_RUNUSER} >& /dev/null;
    printOK $?
    formatOutput "Repair user directory permissions...."
    chown ${FRP_RUNUSER}.${FRP_RUNUSER} ${FRP_PREFIX} -R
    printOK $?
    if [ ! -f "${FRP_PREFIX}/etc/frps_full.ini" ]; then
       cp ${FRP_PREFIX}/frps_full.ini ${FRP_PREFIX}/etc/frps_full.ini
       cp ${FRP_PREFIX}/frpc.ini ${FRP_PREFIX}/etc/frpc.ini
    fi
    if [ "${FRP_TYPE}" == "server" ]; then
        FRP_ADMIN_PASS=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 15`
        formatOutput "Generating Management User admin Password [\033[31m${FRP_ADMIN_PASS}\033[0m] ....."
        printOK $?
        sed -i "s|^dashboard_pwd = admin|dashboard_pwd = ${FRP_ADMIN_PASS}|g" ${FRP_PREFIX}/etc/frps_full.ini
    fi
fi
if [ "${FRP_TYPE}" == "server" ]; then
	FRP_CMD="${FRP_PREFIX}/bin/frps -c ${FRP_PREFIX}/etc/frps_full.ini"
else
	FRP_CMD="${FRP_PREFIX}/bin/frpc -c ${FRP_PREFIX}/etc/frpc.ini"
fi
formatOutput "Current operating mode [${FRP_TYPE}]...."
printOK $?
/usr/sbin/setcap "cap_net_bind_service=+ep" ${FRP_PREFIX}/bin/frps
su-exec ${FRP_RUNUSER}:${FRP_RUNUSER} ${FRP_CMD}
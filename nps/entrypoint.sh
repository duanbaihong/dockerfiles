#!/usr/bin/dumb-init /bin/sh
. /bin/init_nps

formatOutput title
id ${NPS_RUNUSER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    #statements
    formatOutput "Create NPS ${NPS_TYPE} Running User [${NPS_RUNUSER}]...."
    adduser -D -H -s /sbin/nologin -u ${NPS_RUNUSERID} ${NPS_RUNUSER} >& /dev/null;
    printOK $?
    initConfig
    formatOutput "Repair NPS ${NPS_TYPE} user directory permissions...."
    chown ${NPS_RUNUSER}.${NPS_RUNUSER} ${NPS_PREFIX} -R
    printOK $?
    formatOutput title
fi
formatOutput "Start NPS ${NPS_TYPE} for user [${NPS_RUNUSER}] ...."
printOK $?
if [ "$NPS_TYPE" == "Client" ]; then
	/usr/sbin/setcap "cap_net_bind_service=+ep" ${NPS_PREFIX}/npc
	exec ${NPS_PREFIX}/npc
	#statements
else
	/usr/sbin/setcap "cap_net_bind_service=+ep" ${NPS_PREFIX}/nps
	exec ${NPS_PREFIX}/nps
fi
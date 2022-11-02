#!/usr/bin/dumb-init /bin/sh
# 

# 判断用户是否存在
id ${SFTP_USER} &>/dev/null 2>&1
if [ $? -ne 0 ]; then
    adduser -D -h ${SFTP_MOUNTDATADIR} -s /sbin/nologin -u ${SFTP_USERID} -g ${SFTP_USERID} ${SFTP_USER} \
    && echo ${SFTP_USER}:${SFTP_PASS} | chpasswd \
    && ssh-keygen -t ecdsa -f ${SFTP_APPDIR}/key/ecdsa -N "" \
    && chown root.${SFTP_USER} ${SFTP_MOUNTDATADIR}
fi
# 判断配置是否存在
if [ ! -f ${SFTP_APPDIR}/etc/sshd_config ]; then
cat <<EOF >${SFTP_APPDIR}/etc/sshd_config
PasswordAuthentication yes
Subsystem sftp internal-sftp
Match group ${SFTP_USER}
    ChrootDirectory ${SFTP_MOUNTDATADIR}
    X11Forwarding no
    AllowTcpForwarding no
    ForceCommand internal-sftp
EOF

fi

/usr/sbin/sshd -D -h ${SFTP_APPDIR}/key/ecdsa -f ${SFTP_APPDIR}/etc/sshd_config -e $SFTP_ARGS
FROM alpine:latest
MAINTAINER dbh888 <duanbaihong@qq.com>
ENV SFTP_USER=bank_sftpuser \
    SFTP_PASS=ejTlflvVoKP6Ll \
    SFTP_USERID=1000 \
    SFTP_APPDIR=/a/apps/sshd \
    SFTP_MOUNTDATADIR=/mnt/pay 
 
RUN sed -i 's/dl-cdn.alpinelinux.org/repo.huaweicloud.com/g' /etc/apk/repositories \
    && apk add openssh-server tzdata dumb-init vim curl\
    && mkdir ${SFTP_APPDIR}/key ${SFTP_APPDIR}/etc ${SFTP_APPDIR}/bin -p \
    && rm -rf /tmp/* /root/.cache

ADD entrypoint.sh /bin/

WORKDIR ${SFTP_APPDIR}/

ENTRYPOINT /bin/entrypoint.sh
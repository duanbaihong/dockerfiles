ARG CONSUL_VERSION=1.6.1 
FROM alpine:3.10.2
MAINTAINER dbh888<duanbaihong@qq.com>

ENV CONSUL_APPURL=https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip \
    CONSUL_USER=consul \
    CONSUL_DATACENTER='wbd_dc1' \
    CONSUL_BIND='' \
    CONSUL_SERVER=false \
    CONSUL_SERVER_PORT='8300' \
    CONSUL_DNS_PORT='8600' \
    CONSUL_DOMAIN='' \
    CONSUL_HTTP_PORT='8500' \
    CONSUL_HTTP_SSL='false' \
    CONSUL_CACERT='false' \
    CONSUL_HTTPS_PORT='-1' \
    CONSUL_GRPC_PORT='-1' \
    CONSUL_SERF_LAN_PORT='8301' \
    CONSUL_SERF_WAN_PORT='8302' \
    CONSUL_CLIENT='0.0.0.0' \
    CONSUL_BIND_ADDR='' \
    CONSUL_RETRY_JOIN='' \
    CONSUL_ADVERTISE='' \
    CONSUL_ADVERTISE_WAN='' \
    CONSUL_CONFIG_DIR='/consul' \
    CONSUL_CONFIG_FILE='' \
    CONSUL_BOOTSTRAP='false' \
    CONSUL_BOOTSTRAP_EXPECT=2 \
    CONSUL_UI=true \
    CONSUL_UI_DIR='' \
    CONSUL_ENCRYPT='fwhH99sylRt/w3yQ6j2mmA==' \
    CONSUL_MASTER_TOKEN='' \
    CONSUL_AGENT_TOKEN='' \
    CONSUL_DEFAULT_TOKEN='' \
    CONSUL_LOG_LEVEL='INFO' \
    CONSUL_LEAVE_ON_TERMINATE='true' \
    CONSUL_ACL_ENABLE='true' \
    CONSUL_ENABLE_PROMETHEUS='false' \
    IP_DEVICE='eth0' \
    TERM=xterm 
ADD consul entrypoint.sh init_consul /bin/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add openssl su-exec libcap dumb-init \
    && rm -rf /var/cache/apk/* \
    && echo -e "[ ca ]\ndefault_ca= CA_default\n[ CA_default ]\ndir= /demoCA\ncerts= \$dir/certs\ncrl_dir= \$dir/crl\ndatabase= \
\$dir/index.txt\nnew_certs_dir= \$dir/newcerts\ncertificate= \$dir/cacert.pem \nserial= \$dir/serial\npolicy= policy_match\n\
default_md= default\nunique_subject=no\n\
[ policy_match ]\ncountryName= match\nstateOrProvinceName= match\norganizationName= match\norganizationalUnitName= optional\n\
commonName= supplied\nemailAddress= optional\n">>/etc/ssl/openssl.cnf


VOLUME ["${CONSUL_CONFIG_DIR}/"]

ENTRYPOINT ["/bin/entrypoint.sh"]
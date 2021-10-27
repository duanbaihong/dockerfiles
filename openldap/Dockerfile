FROM alpine:3.11
MAINTAINER dbh888<duanbaihong@qq.com>
ARG LDAP_PREFIX=/opt/ldap
ENV OPENLDAP_VERSION=2.6.0 \
    LDAP_ROOT_DOMAIN=openldap \
    LDAP_DOMAIN="zmn.cn" \
    LDAP_DEBUG=256 \
    LDAP_INSTALL_PREFIX=${LDAP_PREFIX} \
    LDAP_DATA_DIR=${LDAP_PREFIX}/data \
    LDAP_RUN_USER=ldap \
    LDAP_RUN_USERID='1000' \
    LDAP_SSL=True \
    LDAP_SYNC_PORT=389 \
    LDAP_ROOT_PASSWORD=duanbai \
    LDAP_ADMIN_USER=admin \
    LDAP_ADMIN_PASSWORD=duanbai \
    LDAP_SYNC_USER=syncuser \
    LDAP_SYNC_USERPASS=syncuser123 \
    LDAP_SYNC_SSL=True \
    LDAP_EMAIL=duanbaihong@qq.com \
    LDAP_CONF_DIR=/etc/ldap \
    LDAP_SSL_CONFIG='' \
    LDAP_MASTER="Master" \
    LDAP_TLS_VERIFY_CLIENT="demand" \
    CMDB_ENABLE="false" \
    CMDB_USER="cmdbadmin" \
    CMDB_PASS="cmdbadmin" \
    PATH=$LDAP_PREFIX/bin:$LDAP_PREFIX/libexec:$PATH \
    PS1='[\u@\w]$'

ADD ldapSshPublicKey.schema personRoles.schema ldapOpenVpnIPtables.schema ldapSamba.schema slapd.conf.templete slapd_slave.conf.templete ldapSshSudo.schema /usr/src/
# ADD openldap-$OPENLDAP_VERSION.tgz \
    # ldapSshPublicKey.schema ldapSamba.schema slapd.conf.templete slapd_slave.conf.templete /usr/src/

RUN installDeps='dumb-init cyrus-sasl openssl libltdl libuuid libintl' \
    && buildDeps='autoconf gcc g++ icu-dev cyrus-sasl-dev db-dev heimdal-dev heimdal-dev groff file openssl-dev libtool m4 mosquitto-dev unixodbc-dev util-linux-dev make perl-dev' \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache $buildDeps $installDeps \
    && OPENLDAP_DOWNLOAD_URL=http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-$OPENLDAP_VERSION.tgz \
    && cd /usr/src \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then funwget $1; fi }; \
    for item in ${OPENLDAP_DOWNLOAD_URL}; do funwget $item; done \
    && cd openldap-$OPENLDAP_VERSION \
    &&  ./configure \
        --prefix=${LDAP_INSTALL_PREFIX} \
        --datadir=${LDAP_DATA_DIR} \
        --enable-slapd \
        --enable-dynacl \
        --enable-aci \
        --enable-cleartext \
        --enable-crypt \
        --enable-lmpasswd \
        --enable-spasswd \
        --enable-modules \
        --enable-rewrite \
        --enable-rlookups \
        --enable-slapi \
        --enable-sql=mod \
        --enable-backends=mod \
        --enable-bdb=mod \
        --enable-dnssrv=mod \
        --enable-hdb=yes \
        --enable-ldap=yes \
        --enable-mdb=yes \
        --enable-monitor=yes \
        --enable-meta=mod \
        --enable-null=mod \
        --enable-passwd=mod \
        --enable-relay=mod \
        --enable-sock=mod \
        --enable-ndb=no \
        --enable-memberof=mod \
        --enable-overlays=mod \
        --enable-accesslog=mod \
        --enable-refint=mod \
        --enable-auditlog=mod \
        --enable-syncprov=mod \
        --enable-ppolicy=mod \
        --enable-valsort=mod \
        --enable-unique=mod \
        --with-threads \
        --with-tls \
        --enable-local \
        --enable-static=no \
        --enable-wt=no \
    && make -j$(nproc) \
    && make install \
    && cd contrib/slapd-modules/smbk5pwd \
    && make prefix=${LDAP_INSTALL_PREFIX} install \
    && cd /usr/src \
    && cp /usr/src/ldapSamba.schema ${LDAP_INSTALL_PREFIX}/etc/openldap/schema/ldapSamba.schema \
    && cp /usr/src/personRoles.schema ${LDAP_INSTALL_PREFIX}/etc/openldap/schema/personRoles.schema \
    && cp /usr/src/ldapSshPublicKey.schema ${LDAP_INSTALL_PREFIX}/etc/openldap/schema/ldapSshPublicKey.schema \
    && cp /usr/src/ldapSshSudo.schema ${LDAP_INSTALL_PREFIX}/etc/openldap/schema/ldapSshSudo.schema \
    && cp /usr/src/ldapOpenVpnIPtables.schema ${LDAP_INSTALL_PREFIX}/etc/openldap/schema/ldapOpenVpnIPtables.schema \
    && cp /usr/src/slapd.conf.templete ${LDAP_INSTALL_PREFIX}/etc/openldap/slapd.conf.templete \
    && cp /usr/src/slapd_slave.conf.templete ${LDAP_INSTALL_PREFIX}/etc/openldap/slapd_slave.conf.templete \
    && rm -rf openldap-$OPENLDAP_VERSION ldapSshPublicKey.schema ldapSamba.schema slapd.conf.templete slapd_slave.conf.templete smbk5pwd.patch \
    && apk del $buildDeps \
    && rm -rf /var/cache/apk/*  \
    && ln -sf  ${LDAP_INSTALL_PREFIX}/libexec/slapd /usr/bin/slapd \
    && echo -e "[ ca ]\ndefault_ca= CA_default\n[ CA_default ]\ndir= /demoCA\ncerts= \$dir/certs\ncrl_dir= \$dir/crl\ndatabase= \
\$dir/index.txt\nnew_certs_dir= \$dir/newcerts\ncertificate= \$dir/cacert.pem \nserial= \$dir/serial\npolicy= policy_match\n\
default_md= default\nunique_subject=no\n\
[ policy_match ]\ncountryName= match\nstateOrProvinceName= match\norganizationName= match\norganizationalUnitName= optional\n\
commonName= supplied\nemailAddress= optional\n">>/etc/ssl/openssl.cnf

EXPOSE 389 636
COPY entrypoint.sh init_openldap /bin/
VOLUME ["${LDAP_CONF_DIR}", "${LDAP_DATA_DIR}"]
WORKDIR ${LDAP_INSTALL_PREFIX}
ENTRYPOINT ["/bin/entrypoint.sh"]

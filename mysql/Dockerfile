FROM alpine:3.11
MAINTAINER dbh888<duanbaihong@qq.com>
ARG MYSQL_INSTALL_DIR=/opt/mysql
ENV MYSQL_VERSION=8.0.20 \
    MYSQL_JEMALLOC_VER=5.2.1 \
    MYSQL_PREFIX=$MYSQL_INSTALL_DIR \
    MYSQL_USER=mysql \
    MYSQL_USERID='1000' \
    MYSQL_PASSWORD='' \
    PATH=$MYSQL_INSTALL_DIR/bin:$PATH \
    PS1='[\u@\w]$' 

ADD entrypoint.sh init_mysql /bin/

    # && cd /tmp;gcc -o /bin/formatmsg formatmsg.c;chmod +x /bin/formatmsg\
    # MYSQL_URL=http://192.168.99.140/mysql-boost-${MYSQL_VERSION}.tar.gz;\
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
    MYSQL_URL=https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-${MYSQL_VERSION}.tar.gz;\
    MYSQL_JEMALLOC_URL=https://github.com/jemalloc/jemalloc/archive/${MYSQL_JEMALLOC_VER}.tar.gz; \
    MAKE_PACKAGE='gcc g++ make cmake autoconf libstdc++ linux-headers openssl-dev ncurses-dev libtirpc-dev zlib-dev icu libevent-dev cyrus-sasl-dev wget upx' \
    DEPENDENCY_PACKAGE='dumb-init icu-libs ncurses-libs bison rpcgen zlib libevent curl openssl' \
    && apk add ${MAKE_PACKAGE} ${DEPENDENCY_PACKAGE}\
    && cd /tmp \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then funwget $1; fi }; \
    for item in ${MYSQL_URL} ${MYSQL_JEMALLOC_URL}; do funwget $item; done \
    && cd /tmp/jemalloc-${MYSQL_JEMALLOC_VER} \
    && ./autogen.sh \
    && make -j4 \
    && make install_lib \
    && cd /tmp/mysql-${MYSQL_VERSION} \
    && cmake . -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_INSTALL_PREFIX=${MYSQL_PREFIX} \
       -DMYSQL_DATADIR=${MYSQL_PREFIX}/data \
       -DSYSCONFDIR=${MYSQL_PREFIX}/etc \
       -DWITH_INNODB_MEMCACHED=ON \
       -DENABLED_LOCAL_INFILE=ON \
       -DDEFAULT_CHARSET=utf8mb4 \
       -DDEFAULT_COLLATION=utf8mb4_general_ci \
       -DFORCE_INSOURCE_BUILD=ON \
       -DWITH_JEMALLOC=ON \
       -DWITH_BOOST=boost/boost_1_70_0/ \
       -DWITH_ZLIB=bundled \
       -DMYSQL_UNIX_ADDR=${MYSQL_PREFIX}/run/mysql.sock \
       -DMYSQLX_UNIX_ADDR=${MYSQL_PREFIX}/run/mysqlx.sock \
       -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
       -DWITH_UNIT_TESTS=OFF \
       -DUSE_LD_LLD=ON \
       -DUSE_LD_GOLD=OFF \
       -DWITH_AUTHENTICATION_LDAP=OFF \
       -DINSTALL_MYSQLTESTDIR="" \
       -DWITH_CURL=system \
       -DLIBEVENT_INCLUDE_DIRS=/usr/include \
    && make -j4 \
    && make install/strip\
    && upx -9 ${MYSQL_PREFIX}/bin/*;upx -d ${MYSQL_PREFIX}/bin/mysql_config;upx -d ${MYSQL_PREFIX}/bin/mysqld_safe \
    && apk del ${MAKE_PACKAGE} \
    && mkdir -p ${MYSQL_PREFIX}/data ${MYSQL_PREFIX}/binlog ${MYSQL_PREFIX}/logs\
    && rm /tmp/* /var/cache/apk/* /usr/local/lib/*.a -rf 

VOLUME ["${MYSQL_PREFIX}/etc","${MYSQL_PREFIX}/data","${MYSQL_PREFIX}/binlog","${MYSQL_PREFIX}/logs"]

EXPOSE 3306

WORKDIR ${MYSQL_PREFIX}
ENTRYPOINT ["/bin/entrypoint.sh"]

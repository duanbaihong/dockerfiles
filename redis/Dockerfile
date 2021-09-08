FROM alpine:3.11
MAINTAINER dbh888<duanbaihong@qq.com>
ARG REDIS_INSTALL=/opt/redis

ENV IP_DEVICE='eth0' \
    REDIS_VERSION='5.0.5' \
	REDIS_PORT=6379 \
	REDIS_ADDR=0.0.0.0 \
    REDIS_USER_UID=1000 \
    REDIS_USER='redis' \
    REDIS_TYPE='server' \
    REDIS_LOGLEVEL='notice' \
    REDIS_PREFIX=$REDIS_INSTALL \
    REDIS_DUBUG='true' \
    PATH=$REDIS_INSTALL/bin:$PATH \
    PS1='[\u@\w]$'

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories\
    && REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
    && reinstallDeps='gcc g++ make linux-headers upx' \
    && installDeps='su-exec dumb-init' \
    && apk add --no-cache ${installDeps} ${reinstallDeps} \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then funwget $1; fi }; \
    for item in ${REDIS_DOWNLOAD_URL}; do funwget $item; done \
    && cd redis-${REDIS_VERSION} \
    && make -j4 \
    && make PREFIX=${REDIS_PREFIX} install \
    && upx -9 ${REDIS_PREFIX}/bin/* || echo \
    && mkdir -p ${REDIS_PREFIX}/etc ${REDIS_PREFIX}/data ${REDIS_PREFIX}/example \
    && cp *.conf ${REDIS_PREFIX}/example \
    && apk del ${reinstallDeps} \
    && rm -rf /var/cache/apk/* ../redis-${REDIS_VERSION}

COPY entrypoint.sh init_redis /bin/

VOLUME ["${REDIS_PREFIX}/data"]

WORKDIR ${REDIS_PREFIX}

EXPOSE 6379 26379

ENTRYPOINT ["/bin/entrypoint.sh"]
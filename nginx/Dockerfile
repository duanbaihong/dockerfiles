FROM alpine:3.10.2
MAINTAINER dbh888<duanbaihong@qq.com>
ARG NGINX_INSTALL=/opt/nginx
ENV NGINX_VERSION=1.20.1 \
    NGX_OPENSSL_VER=1.1.1k \
    NGX_PCRE_VER=8.44 \
    NGX_JEMALLOC_VER=5.2.1 \
    NGX_ZLIB_VER=1.2.11 \
    NGX_MODEL_VTS_VER=0.1.18 \
    NGX_MODEL_DYNAMIC_UPSTREAM_VER=0.1.6 \
    NGX_MODEL_HEADERS_MORE_NGINX_VER=0.33 \
    NGX_MODEL_TIME_VARIABLE_VER=0.0.3 \
    NGX_MODULE_FANCYINDEX_VER=0.5.1 \
    NGX_MODEL_CONCAT_VER=1.2.2 \
    NGX_FREETYPE_VER=2.10.0 \
    NGINX_PREFIX=$NGINX_INSTALL \
    NGINX_USERID='1000' \
    NGINX_USER=nginx \
    PATH=$NGINX_INSTALL/sbin:$PATH \
    PS1='[\u@\w]$'

ADD entrypoint.sh init_nginx /bin/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && NGINX_URL=http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz;\
    NGINX_OPENSSL_URL=https://www.openssl.org/source/openssl-${NGX_OPENSSL_VER}.tar.gz;\
    NGINX_PCRE_URL=https://ftp.pcre.org/pub/pcre/pcre-${NGX_PCRE_VER}.tar.gz;\
    NGINX_ZLIB_URL=https://github.com/madler/zlib/archive/v${NGX_ZLIB_VER}.tar.gz;\
    NGINX_JEMALLOC_URL=https://github.com/jemalloc/jemalloc/archive/${NGX_JEMALLOC_VER}.tar.gz;\
    NGINX_MODULE_VTS_URL=https://github.com/vozlt/nginx-module-vts/archive/v${NGX_MODEL_VTS_VER}.tar.gz ;\
    NGINX_MODULE_DYNAMIC_UPSTREAM_URL=https://github.com/cubicdaiya/ngx_dynamic_upstream/archive/v${NGX_MODEL_DYNAMIC_UPSTREAM_VER}.tar.gz;\
    NGINX_MODULE_HEADERS_MORE_URL=https://github.com/openresty/headers-more-nginx-module/archive/v${NGX_MODEL_HEADERS_MORE_NGINX_VER}.tar.gz;\
    NGINX_MODULE_EXTRA_VARIABLES_URL=https://github.com/duanbaihong/nginx_module/archive/v${NGX_MODEL_TIME_VARIABLE_VER}.tar.gz ;\
    NGINX_MODULE_CONCAT_URL=https://github.com/alibaba/nginx-http-concat/archive/${NGX_MODEL_CONCAT_VER}.tar.gz;\
    NGINX_MODULE_FANCYINDEX="https://github.com/aperezdc/ngx-fancyindex/archive/v${NGX_MODULE_FANCYINDEX_VER}.tar.gz" \
    NGINX_FREETYPE=https://download.savannah.gnu.org/releases/freetype/freetype-${NGX_FREETYPE_VER}.tar.gz; \
    MAKE_PACKAGE='upx gcc g++ make autoconf gd-dev geoip-dev linux-headers libgd tzdata libstdc++ libpng-dev libpng-static jpeg-dev freetype-dev fontconfig-dev'; \
    DEPENDENCY_PACKAGE='su-exec geoip logrotate dumb-init bash inotify-tools' \
    && apk add ${MAKE_PACKAGE} ${DEPENDENCY_PACKAGE}\
    && cd /tmp \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi }; \
    for item in ${NGINX_MODULE_VTS_URL} ${NGINX_MODULE_DYNAMIC_UPSTREAM_URL} ${NGINX_MODULE_HEADERS_MORE_URL} ${NGINX_MODULE_EXTRA_VARIABLES_URL} \
    ${NGINX_MODULE_CONCAT_URL} ${NGINX_URL} ${NGINX_FREETYPE} ${NGINX_OPENSSL_URL} ${NGINX_PCRE_URL} ${NGINX_JEMALLOC_URL} ${NGINX_ZLIB_URL} ${NGINX_MODULE_FANCYINDEX}; \
    do funwget $item; done \
    && cd /tmp/jemalloc-${NGX_JEMALLOC_VER} \
    && ./autogen.sh \
    && make -j4 \
    && make install_lib \
    && cd /tmp/freetype-${NGX_FREETYPE_VER} \
    && ./configure --with-bzip2=no --enable-static && make -j4 && make install \
    && cd /tmp/nginx-${NGINX_VERSION} \
    && sed -i 's|"Server: nginx"|"Server: WoodpeckerTech"|g' src/http/ngx_http_header_filter_module.c \
    && sed -i 's|static const u_char nginx\[5\] = "\\x84\\xaa\\x63\\x55\\xe7"|static const u_char nginx[13] = "\\x8a\\xe4\\x73\\xc9\\x59\\x49\\xd4\\xb6\\x6f\\x29\\x27"|g' src/http/v2/ngx_http_v2_filter_module.c \
    && sed -i 's|server: nginx|server: WoodpeckerTech|g' src/http/v2/ngx_http_v2_filter_module.c \
    && sed -i 's|"<hr><center>nginx</center>"|"<hr><center>WoodpeckerTech</center>"|g' src/http/ngx_http_special_response.c \
    && ./configure --prefix=${NGINX_PREFIX}  \
        --user=${NGINX_USER} \
        --with-openssl=../openssl-${NGX_OPENSSL_VER} \
        --with-zlib=../zlib-${NGX_ZLIB_VER} \
        --with-pcre=../pcre-${NGX_PCRE_VER} \
        --with-poll_module \
        --with-threads \
        --with-compat \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_image_filter_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_stub_status_module \
        --with-http_geoip_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_geoip_module \
        --with-mail=dynamic \
        --with-http_sub_module \
        --with-file-aio \
        --add-dynamic-module= \
        --add-module=../ngx_dynamic_upstream-${NGX_MODEL_DYNAMIC_UPSTREAM_VER}  \
        --add-module=../nginx_module-${NGX_MODEL_TIME_VARIABLE_VER} \
        --add-module=../headers-more-nginx-module-${NGX_MODEL_HEADERS_MORE_NGINX_VER}  \
        --add-module=../nginx-module-vts-${NGX_MODEL_VTS_VER}  \
        --add-module=../nginx-http-concat-${NGX_MODEL_CONCAT_VER}  \
        --add-module=../ngx-fancyindex-${NGX_MODULE_FANCYINDEX_VER}  \
        --with-ld-opt='-static -ljemalloc -lgd -lpng -ljpeg -lfontconfig -lfreetype' \
        --with-cc-opt='-static' \
    && make -j4 \
    && make install \
    && upx -9 ${NGINX_PREFIX}/sbin/nginx \
    && apk del ${MAKE_PACKAGE} \
    && rm /tmp/* /var/cache/apk/* /usr/local/lib/* ${NGINX_PREFIX}/conf/nginx.conf -rf 

VOLUME ["${NGINX_PREFIX}/conf/conf.d","${NGINX_PREFIX}/html","${NGINX_PREFIX}/logs"]

EXPOSE 80 443

WORKDIR ${NGINX_PREFIX}

ENTRYPOINT ["/bin/entrypoint.sh"]

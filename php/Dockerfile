FROM alpine
MAINTAINER dbh888<duanbaihong@qq.com>

ENV IP_DEVICE='eth0' \
	PHP_FPM_PORT=9001 \
	PHP_FPM_ADDR=0.0.0.0 \
    PHP_DATA_DIR=/data/www \
    PHP_USER_UID=1000 \
    PHP_USER=php \
    PHP_FPM_DUBUG='true' \
    TERM=xterm 
RUN installDeps='php7 php7-mysqli php7-ftp php7-sysvmsg \
    php7-memcached php7-sockets php7-mcrypt php7-bcmath \
    php7-calendar php7-tidy php7-gd php7-ldap php7-opcache \
    php7-exif php7-mbstring php7-redis php7-fpm php7-intl \
    php7-fileinfo php7-sysvsem php7-pcntl php7-pdo_mysql \
    php7-ctype php7-zip php7-curl php7-iconv php7-json' \
    && apk add  su-exec libcap dumb-init  $installDeps \
    && rm -rf /var/cache/apk/* \
    && mkdir /opt/data/www -p
COPY entrypoint.sh init_php /bin/
VOLUME ["$PHP_DATA_DIR"]
ENTRYPOINT ["/bin/entrypoint.sh"]
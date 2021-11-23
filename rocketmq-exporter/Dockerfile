FROM pre-harbor.xiujiadian.com/library/oracle-jdk:v1.8.0-301
MAINTAINER dbh888<duanbaihong@qq.com>
ENV PATH=/sbin:/bin:/usr/bin:/usr/sbin:/usr/local/bin:/a/apps/java/bin \
    JAVA_HOME=/a/apps/java \
    ROCKETMQ_ADDR=127.0.0.1:9876

USER zmn
ADD --chown=zmn rocketmq-exporter.jar /a/domains/rocketmq-exporter/
WORKDIR /a/domains/rocketmq-exporter/
EXPOSE  5557
ENTRYPOINT ["java","-jar","/a/domains/rocketmq-exporter/rocketmq-exporter.jar","--rocketmq.config.namesrvAddr=${ROCKETMQ_ADDR}"]
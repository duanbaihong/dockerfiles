
# FROM alpine:3.13 as build-go
# MAINTAINER dbh888<duanbaihong@qq.com>

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
#     && apk add go upx git\
#     && cd / \
#     && git clone https://github.com.cnpmjs.org/kmodules/peer-finder.git \
#     && cd peer-finder \
#     && go env -w GO111MODULE=on \
#     && go env -w GOPROXY=https://goproxy.io \
#     && go install \
#     && go build -ldflags="-w -s" \
#     && upx -9 peer-finder
# ADD entrypoint.sh on-change.sh on-start.sh /peer-finder/



FROM anapsix/alpine-java:latest
ARG NACOS_PREFIX=/a/apps 
MAINTAINER dbh888 <duanbaihong@qq.com>

ENV PATH=$PATH:/opt/jdk/bin \
    NACOS_VERSION=2.0.2 \
    NACOS_PREFIX=${NACOS_PREFIX} \
    JVM_OPTS="" \
    CLUSTER_TYPE= \
    CLUSTER_CONF=${NACOS_PREFIX}/nacos/conf \
    PS1='[\u@\w]$' 

# COPY --from=build-go /peer-finder/peer-finder /peer-finder/*.sh /bin/
ADD entrypoint.sh /bin/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add bash dumb-init \
    && funwget() { wget -c -t 0 $1 -O - |tar -zxf -; if [ $? -ne 0 ]; then echo $1;funwget $1; fi } \
    && mkdir -p ${NACOS_PREFIX}; cd ${NACOS_PREFIX}/ \
    && funwget https://pd.zwc365.com/seturl/https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.tar.gz \
    && cd nacos;rm NOTICE LICENSE -f 
WORKDIR ${NACOS_PREFIX}/nacos/
ENTRYPOINT ["/bin/entrypoint.sh"]


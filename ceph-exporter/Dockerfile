FROM alpine:3.13 as build-go
MAINTAINER dbh888<duanbaihong@qq.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add go upx ceph-dev linux-headers\
    && mkdir /builddir; cd /builddir/ \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.io \
    && go get -u -v github.com/digitalocean/ceph_exporter \
    && cp ~/go/bin/ceph_exporter . \
    && upx -9 ceph_exporter

FROM alpine:3.13
COPY --from=build-go /builddir/ceph_exporter /bin/ceph_exporter
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache add ceph-common upx \
    && chmod +x /bin/ceph* \
    && upx -9 /usr/bin/* ;\
    apk del upx 
ENTRYPOINT ["/bin/ceph_exporter"]
FROM alpine:3.13 as build-go
MAINTAINER dbh888<duanbaihong@qq.com>

ADD go.mod main.go /provisioner/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add go upx \
    && cd /provisioner/ \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.io \
    && GO111MODULE=on GOPROXY=https://goproxy.cn go install \
    && go build -ldflags="-w -s" \
    && upx -9 cephfs-provisioner

FROM alpine:3.13
COPY --from=build-go /provisioner/cephfs-provisioner /bin/cephfs-provisioner
ADD cephfs_provisioner.py /bin/cephfs_provisioner
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache add ceph-common upx \
    && chmod +x /bin/cephfs* \
    && upx -9 /usr/bin/* ;\
    apk del upx 
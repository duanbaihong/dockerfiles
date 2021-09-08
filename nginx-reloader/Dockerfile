FROM alpine:3.14.0 as build-go
MAINTAINER dbh888<duanbaihong@qq.com>

ADD go.mod nginx-reloader.go  /build/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add go upx \
    && cd /build/ \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.io \
    && go install \
    && go build -ldflags="-w -s" \
    && upx -9 nginx-reloader

FROM alpine:3.14.0
COPY --from=build-go  /build/nginx-reloader /bin/nginx-reloader
ENTRYPOINT ["/bin/nginx-reloader"]

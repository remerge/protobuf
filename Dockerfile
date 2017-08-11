FROM golang:alpine as builder

COPY . /protobuf

RUN apk add --update git build-base autoconf automake libtool
RUN cd /protobuf && ./autogen.sh && ./configure --prefix=/usr && make -j 3 && make check && make install
RUN go get -u github.com/gogo/protobuf/protoc-gen-gogofaster

FROM alpine:latest as runner
COPY --from=builder /go/bin/protoc-gen-gogofaster /usr/bin/protoc-gen-gogofaster
COPY --from=builder /usr/bin/protoc /usr/bin/protoc
COPY --from=builder /usr/lib/libprotoc.so.11 /usr/lib/
COPY --from=builder /usr/lib/libprotobuf.so.11 /usr/lib/
RUN apk add --update libstdc++

VOLUME /src
WORKDIR /src

ENTRYPOINT ["protoc"]

FROM golang:alpine as builder

VOLUME /src
WORKDIR /src

COPY . /protobuf
COPY docker-build.sh /docker-build.sh
RUN /docker-build.sh

RUN apk add --update git
RUN go get -u github.com/gogo/protobuf/protoc-gen-gogofaster

FROM alpine:latest as runner
COPY --from=builder /go/bin/protoc-gen-gogofaster /bin/protoc-gen-gogofaster
COPY --from=builder /usr/bin/protoc /usr/bin/protoc
COPY --from=builder /usr/lib/libprotoc.so* /usr/lib/
COPY --from=builder /usr/lib/libprotobuf.so* /usr/lib/
RUN apk add --update libstdc++

ENTRYPOINT ["protoc"]

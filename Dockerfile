FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  build-essential \
  curl \
  libtool \
  unzip \
&& rm -rf /var/lib/apt/lists/*

COPY . /protobuf
RUN cd protobuf && ./autogen.sh && ./configure && make && make check && make install && ldconfig && cd .. && rm -rf protobuf

RUN apt-get update && apt-get install -y \
  software-properties-common \
  python-software-properties \
&& add-apt-repository ppa:longsleep/golang-backports && apt-get update && apt-get install -y \
  git \
  golang-1.8-go \
&& rm -rf /var/lib/apt/lists/* && ln -s /usr/lib/go-1.8/bin/go /usr/bin/go

RUN mkdir /go
ENV PATH="/go/bin:${PATH}" GOPATH="/go"
RUN go get -u github.com/gogo/protobuf/protoc-gen-gogofaster

VOLUME /src
WORKDIR /src

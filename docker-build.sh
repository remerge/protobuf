#!/usr/bin/env sh
set -e
apk add --update git build-base autoconf automake libtool
cd /protobuf
./autogen.sh && ./configure --prefix=/usr && make -j 3 && make check && make install

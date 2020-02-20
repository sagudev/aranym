#!/bin/bash
sudo apt-get update
sudo apt-get install -y -qq \
	curl \
	wget \
	git \
	zsync \
	xz-utils \
	libjson-perl \
	libwww-perl \
	lsb-release
if ! ( echo $is | grep -q deploy ); then
	docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
	docker run --rm arm64v8/ubuntu:16.04 uname -a
	docker run --rm arm32v7/ubuntu:16.04 uname -a
	docker run --rm i386/ubuntu:16.04 uname -a
fi
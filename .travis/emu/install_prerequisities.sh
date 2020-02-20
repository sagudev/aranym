#!/bin/bash
if ! ( echo $is | grep -q deploy ); then
	sudo service docker stop
	sudo dockerd --experimental &> /dev/null &
	docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
	docker run --rm --env-file <(env) arm64v8/ubuntu:16.04 env
	docker run --rm arm32v7/ubuntu:16.04 uname -a
	docker run --rm --platform 386 ubuntu:16.04 uname -a
else
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
fi
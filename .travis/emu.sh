#!/bin/bash
if ! [ "$deploy" = true ]; then
	sudo service docker stop
	sudo dockerd --experimental &> /dev/null &
	docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
	case "$arch_build" in
		i386)
			docker run --rm --env-file <(env) \
				-v "/home/travis":"/home/travis" -w "/home/travis" \
				--platform 386 ubuntu:16.04 "${TRAVIS_BUILD_DIR}/.travis/in_emu.sh"
		;;
		armhf)
			docker run --rm --env-file <(env) \
				-v "/home/travis":"/home/travis" -w "/home/travis" \
				arm32v7/ubuntu:16.04 "${TRAVIS_BUILD_DIR}/.travis/in_emu.sh"
		;;
		aarch)
			docker run --rm --env-file <(env) \
				-v "/home/travis":"/home/travis" -w "/home/travis" \
				arm64v8/ubuntu:16.04 "${TRAVIS_BUILD_DIR}/.travis/in_emu.sh"	
		;;
	esac
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
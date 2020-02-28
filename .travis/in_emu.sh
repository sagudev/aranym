#!/bin/bash
if [ -z "$BINTRAY_API_KEY" ]
then
	echo "error: BINTRAY_API_KEY is undefined" >&2
fi
uname -a
apt update
cd "/home/travis/build/${TRAVIS_REPO_SLUG}"
cat > ~/.sbuildrc << __EOF__
$apt_allow_unauthenticated = 1;

# Directory for writing build logs to
$log_dir=$ENV{HOME}."/ubuntu/logs";

# don't remove this, Perl needs it:
1;
__EOF__
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"
export emu=true
apt install -y locales sudo tree
locale-gen en_US.UTF-8

. ./.travis/install_prerequisities.sh
. ./.travis/setup_env.sh
if ! [ "$deploy" = true ]; then
. ./.travis/build.sh
fi
tree -a
if ( echo $arch_build | grep -q i386 ) || [ -z "$arch" ]; then # we run deploy in emu just for building snaps
. ./.travis/deploy.sh
fi
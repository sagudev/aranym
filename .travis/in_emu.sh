#!/bin/bash
if [ -z "$BINTRAY_API_KEY" ]
then
	echo "error: BINTRAY_API_KEY is undefined" >&2
fi
uname -a
apt update
apt install sudo -y -qq
cd "/home/travis/build/${TRAVIS_REPO_SLUG}"
cat > ~/.sbuildrc << __EOF__
$apt_allow_unauthenticated = 1;

# Directory for writing build logs to
$log_dir=$ENV{HOME}."/ubuntu/logs";

# don't remove this, Perl needs it:
1;
__EOF__
#echo "LC_ALL=en_US.UTF-8" >> /etc/environment
#echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
#echo "LANG=en_US.UTF-8" > /etc/locale.conf
#locale-gen en_US.UTF-8
export LANG=en_US.utf8
apt install -y locales
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
. ./.travis/install_prerequisities.sh
. ./.travis/setup_env.sh
. ./.travis/build.sh
#if !( echo $arch_build | grep -q i386 ); then 
#. ./.travis/deploy.sh
#fi
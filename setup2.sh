#!/bin/bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_or_update_repo() {
    local USER=$1
    local REPO=$2
    local BRANCH=$3
    local DIR=${4-${REPO}}
    if [[ ! -e ${DIR} ]]; then
        su -c "git clone --branch ${BRANCH} git://github.com/mattgodbolt/${REPO}.git ${DIR}" "${USER}"
    else
        su -c "cd ${DIR}; git pull && git checkout ${BRANCH}" "${USER}"
    fi
}

apt-get -y update
apt-get -y upgrade --force-yes
apt-get -y install git make nodejs-legacy npm docker.io libpng-dev m4

if ! grep ubuntu /etc/passwd; then
    useradd ubuntu
    mkdir /home/ubuntu
    chown ubuntu /home/ubuntu
fi

# TODO needs to support node being "nodejs"
cd /home/ubuntu/
get_or_update_repo ubuntu jsbeeb release
pushd jsbeeb
su -c "make dist" ubuntu
popd
get_or_update_repo ubuntu jsbeeb master jsbeeb-beta
pushd jsbeeb-beta
su -c "make dist" ubuntu
popd

# needs docker login
cp /gcc-explorer-image/docker-init.conf /etc/init/
service docker-init start

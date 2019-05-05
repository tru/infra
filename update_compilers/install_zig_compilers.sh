#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${SCRIPT_DIR}/common.inc

install_zig() {
    local VERSION=$1
    local DIR=zig-${VERSION}
    if [[ -d ${DIR} ]]; then
        echo Zig $VERSION already installed, skipping
        return
    fi
    mkdir ${DIR}
    pushd ${DIR}

    fetch https://ziglang.org/download/${VERSION}/zig-linux-x86_64-${VERSION}.tar.xz | tar Jxf - --strip-components 1
    rm -f langref.html

    popd
    do_strip ${DIR}
}


install_zig_nightly() {
    local VERSION=$1
    local DIR=zig-${VERSION}

    if [[ -d ${DIR} ]]; then
        rm -rf ${DIR}
    fi

    mkdir ${DIR}
    pushd ${DIR}
    fetch https://ziglang.org/builds/zig-linux-x86_64-${VERSION}.tar.xz | tar Jxf - --strip-components 1
    rm -f langref.html

    popd
    do_strip ${DIR}
}

install_zig 0.2.0
install_zig 0.3.0
install_zig 0.4.0

# Disabled, see https://github.com/mattgodbolt/compiler-explorer-image/issues/200
# The URL has changed and includes a version and SHA now
#if install_nightly; then
#    install_zig_nightly master
#fi

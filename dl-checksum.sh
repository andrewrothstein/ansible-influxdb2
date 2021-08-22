#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://dl.influxdata.com/influxdb/releases

dl() {
    local ver=$1
    local os=$2
    local arch=$3
    local archive_type=${4:-tar.gz}
    local platform="${os}-${arch}"
    local file="influxdb2-${ver}-${platform}.${archive_type}"
    # https://dl.influxdata.com/influxdb/releases/influxdb2-2.0.6-linux-amd64.tar.gz
    local url=$MIRROR/$file
    local lfile=$DIR/$file

    if [ ! -e $lfile ];
    then
        wget -q -O $lfile $url
    fi
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64
    dl $ver linux amd64
    dl $ver linux arm64
}

dl_ver ${1:-2.0.8}

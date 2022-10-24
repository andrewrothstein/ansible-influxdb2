#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://dl.influxdata.com/influxdb/releases

dl_app() {
    local ver=$1
    local app=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}-${arch}"
    local file=""
    if [ "$app" = "influxd" ];
    then
        # https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.4.0-linux-amd64.tar.gz
        file="influxdb2-${ver}-${platform}.${archive_type}"
    elif [ "$app" = "influx" ];
    then
        # https://dl.influxdata.com/influxdb/releases/influxdb2-2.4.0-linux-amd64.tar.gz
        file="influxdb2-client-${ver}-${platform}.${archive_type}"
    else
        echo "unknown app: $app"
        exit -1
    fi
    local url=$MIRROR/$file
    local lfile=$DIR/$file

    if [ ! -e $lfile ];
    then
        curl -sSLf -o $lfile $url
    fi
    if [ -e $lfile ];
    then
        printf "      # %s\n" $url
        printf "      %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
    fi
}

dl_ver_app() {
    local ver=$1
    local app=$2
    printf "    %s:\n" $app
    dl_app $ver $app darwin amd64
    dl_app $ver $app linux amd64
    dl_app $ver $app linux arm64
    dl_app $ver $app windows amd64 zip
}

dl_ver() {
    local ver=$1
    printf "  '%s':\n" $ver
    dl_ver_app $ver influxd
    dl_ver_app $ver influx
}

dl_ver ${1:-2.4.0}

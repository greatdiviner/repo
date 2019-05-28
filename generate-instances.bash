#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <base-pkg> <start-num> <total-num>"
    exit 1
fi

BASE_PKG=$1
START_NUM=$2
TOTAL_NUM=$3

if [ -d "$BASE_PKG" ];then
    echo "input base-pkg is a directory."
elif [ -f "$BASE_PKG" -a "${BASE_PKG##*.}"x = "tgz"x ];then
    echo "input base-pkg is a file."
    rm -rf "${BASE_PKG%.*}"
    mkdir -p "${BASE_PKG%.*}"
    tar -xzf $BASE_PKG -C .
    BASE_PKG="${BASE_PKG%.*}"
fi


generate_instances() {
for((i=0;i<$TOTAL_NUM;i++));
do
    CURRENT_NUM=$(($START_NUM+$i))
    cp -rf $BASE_PKG instance${CURRENT_NUM}
    conf=instance${CURRENT_NUM}/conf/server.ini
    sed -i "s/Hostname=/Hostname=`hostname`-${CURRENT_NUM}/g" $conf
    sed -i "s/59606/$((56000+${CURRENT_NUM}*10))/g" $conf
    sed -i "s/59608/$((57000+${CURRENT_NUM}*10))/g" $conf
    sed -i "s/59843/$((58000+${CURRENT_NUM}*10))/g" $conf
done
}
generate_instances



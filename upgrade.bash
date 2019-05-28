#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <target-dir> <start-num> <total-num>"
    exit 1
fi

TARGET_DIR=$1
START_NUM=$2
TOTAL_NUM=$3

if [ ! -d "$TARGET_DIR" ]; then
    echo "input target-dir does not exist, just created."
    mkdir $TARGET_DIR
elif [ -d "$TARGET_DIR" ];then
    echo "input target-dir is a directory."
else
    echo "input target-dir is not a valid directory."
    exit 1
fi


upgrade() {
for((i=0;i<$TOTAL_NUM;i++));
do

    CURRENT_NUM=$(($START_NUM+$i))
    kill -9 `ps -ef | grep platinumd | grep instance${CURRENT_NUM} | awk '{print $2}' | xargs`

    cp -rf instance${CURRENT_NUM} $TARGET_DIR
    $TARGET_DIR/instance${CURRENT_NUM}/start.sh
done
}
upgrade



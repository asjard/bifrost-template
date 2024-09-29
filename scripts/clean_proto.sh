#!/bin/bash


PROTO_DIR=${PROTO_DIR:-"."}

if [ ! -d "$PROTO_DIR" ];then
    echo "proto dir '$PROTO_DIR' dir not found"
    exit 1
fi

cd $PROTO_DIR

for file in $(find . -type f -name "*.pb.go" -o -name '*.d.ts'|grep -v 'third_party')
do
    rm -rf $file
done

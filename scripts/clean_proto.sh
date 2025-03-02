#!/bin/bash


PROTO_DIR=${PROTO_DIR:-"."}

if [ ! -d "${PROTO_DIR}/${GEN_PROTO_GO_OUT}" ];then
    echo "'${PROTO_DIR}/${GEN_PROTO_GO_OUT}' not found"
    exit 0
fi

cd ${PROTO_DIR}
find . -type f -path '*/third_party/*' -prune -o -name "*.pb.go" -delete

cd -
if [ ! -d "${PROTO_DIR}/${GEN_PROTO_TS_OUT}" ];then
    echo "'${PROTO_DIR}/${GEN_PROTO_GO_OUT}' not found"
    exit 0
fi
cd ${PROTO_DIR}/${GEN_PROTO_TS_OUT}
find . -type f -path '*/third_party/*' -prune -o -name "*.pb.ts" -delete

#

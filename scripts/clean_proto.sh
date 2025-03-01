#!/bin/bash


PROTO_DIR=${PROTO_DIR:-"."}

if [ ! -d "${PROTO_DIR}/${GEN_PROTO_GO_OUT}" ];then
    echo "'${PROTO_DIR}/${GEN_PROTO_GO_OUT}' not found"
    exit 1
fi

find ${PROTO_DIR}/${GEN_PROTO_GO_OUT} -type f -0 -name "*.pb.go" -delete

if [ ! -d "${PROTO_DIR}/${GEN_PROTO_TS_OUT}" ];then
    echo "'${PROTO_DIR}/${GEN_PROTO_TS_OUT}' not found"
    exit 1
fi

find ${PROTO_DIR}/${GEN_PROTO_TS_OUT} -type f -name "*.ts" -delete

#

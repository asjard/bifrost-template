#!/bin/bash -e

ROOTDIR=$(cd $(dirname $0);pwd)
PROTO_DIR=${PROTO_DIR:-"."}

if [ ! -d "$PROTO_DIR" ];then
    echo "$PROTO_DIR dir not found"
    exit 1
fi

protoc_out=

go_out() {
    [[ "$protoc_out" =~ "--go_out=" ]] || protoc_out="$protoc_out --go_out=${GEN_PROTO_GO_OUT}"
}

ts_out() {
    [[ "$protoc_out" =~ "--ts_out=" ]] || protoc_out="$protoc_out --ts_out=${GEN_PROTO_TS_OUT}"
}

ts_enum_out() {
    [[ "$protoc_out" =~ "--ts-enum_out=" ]] || protoc_out="$protoc_out --ts-enum_out=${GEN_PROTO_TS_OUT}"
}

ts_umi_out() {
    [[ "$protoc_out" =~ "--ts-umi_out=" ]] || protoc_out="$protoc_out --ts-umi_out=${GEN_PROTO_TS_OUT}"
}

go_grpc_out(){
    go_out
    [[ "$protoc_out" =~ "--go-grpc_out=" ]] || protoc_out="$protoc_out --go-grpc_out=${GEN_PROTO_GO_OUT}"
}

go_rest_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-rest_out=" ]] || protoc_out="$protoc_out --go-rest_out=${GEN_PROTO_GO_OUT}"
}

go_asynq_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-asynq_out=" ]] || protoc_out="$protoc_out --go-asynq_out=${GEN_PROTO_GO_OUT}"
}

go_rabbitmq_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-rabbitmq_out=" ]] || protoc_out="$protoc_out --go-rabbitmq_out=${GEN_PROTO_GO_OUT}"
}

go_validate_out() {
    go_out
    [[ "$protoc_out" =~ "--go-validate_out=" ]] || protoc_out="$protoc_out --go-validate_out=${GEN_PROTO_GO_OUT}"
}

go_rest_gw_out() {
    go_rest_out
    [[ "$protoc_out" =~ "--go-rest2grpc-gw_out=" ]] || protoc_out="$protoc_out --go-rest2grpc-gw_out=${GEN_PROTO_GO_OUT}"
}

if [  "$GEN_PROTO_GO" == "true" ];then
    go_out
fi

if [ "$GEN_PROTO_GO_GRPC" == "true" ];then
    go_grpc_out
fi

if [ "$GEN_PROTO_GO_REST" == "true" ];then
    go_rest_out
fi

if [ "$GEN_PROTO_GO_ASYNQ" == "true" ];then
    go_asynq_out
fi

if [ "$GEN_PROTO_GO_RABBITMQ" == "true" ];then
    go_rabbitmq_out
fi

if [ "$GEN_PROTO_GO_VALIDATE" == "true" ];then
    go_validate_out
fi

if [ "$GEN_PROTO_GO_REST_GW" == "true" ];then
    go_rest_gw_out
fi

if [ "$GEN_PROTO_TS" == "true" ];then
    ts_out
fi

if [ "$GEN_PROTO_TS_ENUM" == "true" ];then
    ts_enum_out
fi

if [ "$GEN_PROTO_TS_UMI" == "true" ];then
    ts_umi_out
fi

clang_format=$(which clang-format)

## 清理生成的文件
bash ${ROOTDIR}/clean_proto.sh

cd $PROTO_DIR

for file in $(find . -type f -name "*.proto" |grep -v 'third_party')
do
    if [ -n "$clang_format" ];then
        ${clang_format} -i $file
    fi
    protoc ${protoc_out} \
        -I./third_party \
        -I. \
        $file
done

#!/bin/bash -e

ROOTDIR=$(cd $(dirname $0);pwd)
PROTO_DIR=${PROTO_DIR:-"."}

if [ ! -d "$PROTO_DIR" ];then
    echo "$PROTO_DIR dir not found"
    exit 1
fi

protoc_out=

go_out() {
    [[ "$protoc_out" =~ "--go_out=" ]] || protoc_out="$protoc_out --go_out=${GEN_PROTO_GO_OUT} --go_opt=${GEN_PROTO_GO_OPT}"
}

ts_out() {
    [[ "$protoc_out" =~ "--ts_out=" ]] || protoc_out="$protoc_out --ts_out=${GEN_PROTO_TS_OUT} --ts_opt=${GEN_PROTO_TS_OPT}"
}

ts_enum_out() {
    [[ "$protoc_out" =~ "--ts-enum_out=" ]] || protoc_out="$protoc_out --ts-enum_out=${GEN_PROTO_TS_OUT} --ts-enum_opt=${GEN_PROTO_TS_ENUM_OPT}"
}

ts_umi_out() {
    [[ "$protoc_out" =~ "--ts-umi_out=" ]] || protoc_out="$protoc_out --ts-umi_out=${GEN_PROTO_TS_OUT} --ts-umi_opt=${GEN_PROTO_TS_UMI_OPT}"
}

go_grpc_out(){
    go_out
    [[ "$protoc_out" =~ "--go-grpc_out=" ]] || protoc_out="$protoc_out --go-grpc_out=${GEN_PROTO_GO_OUT} --go-grpc_opt=${GEN_PROTO_GO_GRPC_OPT}"
}

go_rest_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-rest_out=" ]] || protoc_out="$protoc_out --go-rest_out=${GEN_PROTO_GO_OUT} --go-rest_opt=${GEN_PROTO_GO_REST_OPT}"
}

go_asynq_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-asynq_out=" ]] || protoc_out="$protoc_out --go-asynq_out=${GEN_PROTO_GO_OUT} --go-asynq_opt=${GEN_PROTO_GO_ASYNQ_OPT}"
}

go_amqp_out() {
    go_grpc_out
    [[ "$protoc_out" =~ "--go-amqp_out=" ]] || protoc_out="$protoc_out --go-amqp_out=${GEN_PROTO_GO_OUT} --go-amqp_opt=${GEN_PROTO_GO_AMQP_OPT}"
}

go_validate_out() {
    go_out
    [[ "$protoc_out" =~ "--go-validate_out=" ]] || protoc_out="$protoc_out --go-validate_out=${GEN_PROTO_GO_OUT} --go-validate_opt=${GEN_PROTO_GO_VALIDATE_OPT}"
}

go_rest_gw_out() {
    go_rest_out
    [[ "$protoc_out" =~ "--go-rest2grpc-gw_out=" ]] || protoc_out="$protoc_out --go-rest2grpc-gw_out=${GEN_PROTO_GO_OUT} --go-rest2grpc-gw_opt=${GEN_PROTO_GO_REST_GW_OPT}"
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

if [ "$GEN_PROTO_GO_AMQP" == "true" ];then
    go_amqp_out
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

cd $PROTO_DIR/../

proto_dir=$(basename $PROTO_DIR)

protoc_opt="${PROTOC_OPT}"
if [ -d ${proto_dir}/third_party ];then
    protoc_opt="${protoc_opt} -I./${proto_dir}/third_party"
fi

protoc_opt="${protoc_opt} -I."



for file in $(find ${proto_dir} -type f -name "*.proto" |grep -v 'third_party')
do
    if [ -n "$clang_format" ];then
        ${clang_format} -i $file
    fi
    protoc ${protoc_out} \
        ${protoc_opt} \
        $file
done

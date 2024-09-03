> 部署模版

## 查看帮助

```bash
make
# 或者
make help
```

效果如下

```bash
Commands:
  help       使用帮助
  build      编译
  archive    打包
  install    安装
  restart    重启
  start      启动
  stop       停止
  uninstall  卸载
  test       运行测试用例
Envs:
  BIFROST_DIR            当前项目所在目录,结尾不要有/                  默认: .            当前: .
  GEN_PROTO_GO           是否根据protobuf文件生成*.pb.go文件           默认: true         当前: true
  GEN_PROTO_GO_GRPC      是否根据protobuf文件生成*_grpc.pb.go文件      默认: true         当前: true
  GEN_PROTO_GO_REST      是否根据protobuf文件生成*_rest.pb.go文件      默认: true         当前: true
  GEN_PROTO_GO_REST_GW   是否根据protobuf文件生成*_rest_gw.pb.go文件   默认: true         当前: true
  GEN_PROTO_TS           是否根据protobuf文件生成*_ts.pb.go文件        默认: false        当前: false
  PROTO_DIR              protobuf所在目录                              默认: ./protobuf   当前: ./protobuf
  GOOS                   运行环境,可选:linux,darwin,windows            默认: linux        当前: linux
  CGO_ENABLED            是否开启CGO,可选:0,1                          默认: 0            当前: 0
  BUILD_DIR              编译目录                                      默认: ./           当前: ./
  DEPLOY_ENV             部署环境,可选:dev,sit,uat,pro                 默认: dev          当前: dev
  SERVICE_NAME           服务名称                                      默认: bifrost      当前: bifrost
```

## 环境变量定义

以`##env开头`开头的下一行可自动识别

```makefile
##env 变量描述
GOOS ?= linux
#   ^  ^
#   |  |
#  一个空格
# GOOS为环境变量名称
# linux为默认值
```

## 指令定义

以`: ##`格式可被自动识别

```makefile
target: ## 指令描述
```

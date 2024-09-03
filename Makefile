##env 当前项目所在目录,结尾不要有/
BIFROST_DIR ?= .

##env 是否根据protobuf文件生成*.pb.go文件
GEN_PROTO_GO ?= true
##env 是否根据protobuf文件生成*_grpc.pb.go文件
GEN_PROTO_GO_GRPC ?= true
##env 是否根据protobuf文件生成*_rest.pb.go文件
GEN_PROTO_GO_REST ?= true
##env 是否根据protobuf文件生成*_rest_gw.pb.go文件
GEN_PROTO_GO_REST_GW ?= true
##env 是否根据protobuf文件生成*_ts.pb.go文件
GEN_PROTO_TS ?= false
##env protobuf所在目录
PROTO_DIR ?= ./protobuf

##env 运行环境,可选:linux,darwin,windows
GOOS ?= linux
##env 是否开启CGO,可选:0,1
CGO_ENABLED ?= 0
##env 编译目录
BUILD_DIR ?= ./

##env 部署环境,可选:dev,sit,uat,pro
DEPLOY_ENV ?= dev
##env 服务名称
SERVICE_NAME ?= bifrost

all: help

## 自动生成的环境变量
-include Makefile_gen
-include Makefile_gen_all_env

all_env:
	@echo "## AUTO GENERATED DO NOT EDIT IT.\nALL_ENV := $$(cat $(MAKEFILE_LIST) |\
	grep -v '^$$'|\
	grep -A1 '^\#\#env'|\
	awk '/\#\#env/{getline a;print a}'|\
	sed 's/ .*=/=/'|\
	sed 's/ .*=/=/'|\
	sed 's/ //g'|\
	sed -e 's/^\(.*\)=.*/\1="$$\(\1\)"/'|\
	tr '\r\n' ' ')" > Makefile_gen_all_env

help: ## 使用帮助
	@echo "Commands:"
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/  \\033[35m\1\\033[m:\2/' | column -c2 -t -s :)"
	@echo "Envs:"
	@echo "## AUTO GENERATED DO NOT EDIT IT.\nenv: \n$$(cat $(MAKEFILE_LIST) | \
	grep -v '^$$' | \
	grep -A1 -E '^##env' |\
	sed 's/##env//' |\
	sed 'N;s/\n/ =/'|\
	awk -F '=' '{print $$2"|"$$1"|默认:"$$3}' | \
	sed -e 's/ .|/|/' -e 's/^\(.\+\)|\(.*\)|\(.*\)/	@echo  \"  \\033[32m\1\\033[m|\2|\3 |当前: $$(\1)\"/' |\
	column -c2 -t -s '|')" > Makefile_gen
	@make env

build: ## 编译
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=amd64 go build -ldflags "-s -w" -o $(SERVICE_NAME) $(BUILD_DIR)

archive: ## 打包

install: all_env $(BIFROST_DIR)/01_install.yaml ## 安装
	ansible-playbook \
	-e '$(ALL_ENV)' \
	-i $(BIFROST_DIR)/inventory.ini \
	01_install.yaml

restart: all_env $(BIFROST_DIR)/02_restart.yaml ## 重启
	ansible-playbook \
	-e '$(ALL_ENV)' \
	-i $(BIFROST_DIR)/inventory.ini \
	02_resstart.yaml

start: all_env $(BIFROST_DIR)/03_start.yaml ## 启动
	ansible-playbook -\
	-e '$(ALL_ENV)' \
	-i $(BIFROST_DIR)/inventory.ini \
	03_start.yaml

stop: all_env $(BIFROST_DIR)/04_stop.yaml ## 停止
	ansible-playbook \
	-e '$(ALL_ENV)' \
	-i $(BIFROST_DIR)/inventory.ini \
	04_stop.yaml

uninstall: all_env $(BIFROST_DIR)/05_uninstall.yaml ## 卸载
	ansible-playbook \
	-e '$(ALL_ENV)' \
	-i $(BIFROST_DIR)/inventory.ini \
	05_uninstall.yaml

test: ## 运行测试用例
	go test -race -cover -coverprofile=cover.out $$(go list ./...|grep -v cmd|grep -v 'protobuf/')
	# go tool cover -html=cover.out

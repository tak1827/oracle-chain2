# TEST_PACKAGES=$(shell go list ./... | grep -v '/simulation' | grep -v '/cli')
TEST_PACKAGES=./...
VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=oraclechain \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=wvchaind \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT)

BUILD_FLAGS := -tags "$(build_tags)" -ldflags '$(ldflags)'

# docker:
# 	docker run -it -v $(shell pwd):/root/vwbl-chain -w /root/vwbl-chain ttakayuki/vwbl bash

.PHONY: proto
proto:
	@ignite generate proto-go

lint:
	@echo "--> Running linter"
	@go vet ./...
	@golangci-lint run --timeout=10m

fmt:
	@gofmt -w -s -l .
	@misspell -w .

test:
	@echo "--> Running tests"
	@go test -mod=readonly -timeout=1m $(TEST_PACKAGES)

install:
	@echo "--> Installing"
	@go install -mod=readonly $(BUILD_FLAGS) ./cmd/oraclechaind

run:
	oraclechaind start --home ./.chaindata --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable --evm.tracer=json --trace

init:
	rm -rf ./.chaindata/*
	oraclechaind init oraclechain --chain-id oraclechain_9000-1 --home ./.chaindata
	oraclechaind config chain-id oraclechain_9000-1 --home ./.chaindata
	oraclechaind config keyring-backend test --home ./.chaindata
	oraclechaind keys add valkey --home ./.chaindata --keyring-backend test --algo eth_secp256k1
	oraclechaind add-genesis-account valkey 10000000000000000000000000aphoton --home ./.chaindata --keyring-backend test
	oraclechaind gentx valkey 10000000000aphoton --home ./.chaindata --chain-id oraclechain_9000-1
	oraclechaind collect-gentxs --home ./.chaindata
	oraclechaind start --home ./.chaindata --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable

reset:
	mv ./.chaindata/data/priv_validator_state.origin.json .
	rm -rf ./.chaindata/data/*
	mv ./priv_validator_state.origin.json ./.chaindata/data/
	cp ./.chaindata/data/priv_validator_state.origin.json ./.chaindata/data/priv_validator_state.json
	rm ./.chaindata/config/write-file*


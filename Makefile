BINARY  := gop-code
VERSION := $(shell git rev-parse --short HEAD 2>/dev/null || echo dev)

.PHONY: help build test clean run

help:
	@grep -E '^[a-zA-Z_-]+:.*' $(MAKEFILE_LIST) | grep -v '^help' | awk -F: '{print $$1}'

build:
	go build -ldflags="-X main.version=$(VERSION)" -o $(BINARY) .

test:
	go test -v ./...

clean:
	rm -f $(BINARY)

run: build
	./$(BINARY)

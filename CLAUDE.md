# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Build binary (version defaults to "dev")
go build -o gop-code .

# Build with version injected
go build -ldflags="-X main.version=$(git rev-parse --short HEAD)" -o gop-code .

# Run locally (listens on :8080)
go run .

# Multi-arch Docker build (amd64 + arm64)
docker buildx build --platform linux/amd64,linux/arm64 -t gop-code .

# Docker build with version
docker buildx build --build-arg VERSION=$(git rev-parse --short HEAD) --platform linux/amd64,linux/arm64 -t gop-code .
```

No external dependencies — stdlib only, no `go mod tidy` needed.

## Architecture

Single-file Go HTTP server (`main.go`) using `net/http` default mux. Two routes:
- `/` — JSON response with message, hostname, version
- `/healthz` — plaintext 200 OK

`version` is a package-level var set to `"dev"` at compile time, overridden via `-ldflags -X main.version=...`.

## Docker

Multi-stage Dockerfile: `golang:1.22-alpine` build stage → `alpine:3.19` runtime. Cross-compilation handled by `TARGETOS`/`TARGETARCH` build args (provided automatically by `docker buildx`). Static binary via `CGO_ENABLED=0`.

## CI/CD

GitHub Actions workflow (`.github/workflows/docker-build.yml`) triggers on push to `main`. Builds multi-arch image and pushes to DockerHub as `<username>/gop-code` tagged with `latest` and short SHA.

Required GitHub repo secrets: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`.

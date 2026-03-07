FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=dev

WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-s -w -X main.version=${VERSION}" -o /gop-code .

FROM alpine:3.19
COPY --from=build /gop-code /gop-code
EXPOSE 8080
ENTRYPOINT ["/gop-code"]

# Build the manager binary
FROM golang:1.13

ARG TARGET_PROJECT

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN GOPROXY="https://goproxy.io" go mod download

# Copy the go source
COPY cmd/${TARGET_PROJECT}/main.go main.go
COPY pkg/ pkg/

# Build
RUN mkdir -p /workspace/bin
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
    go build -a -o bin/${TARGET_PROJECT}-linux-amd64 main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 GO111MODULE=on \
    go build -a -o bin/${TARGET_PROJECT}-linux-arm64 main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 GO111MODULE=on \
    go build -a -o bin/${TARGET_PROJECT}-linux-arm main.go

# CI Build
FROM golang:1.19.10-bookworm as builder
COPY ./src /build/src
WORKDIR /build/src
ENV GO111MODULE=on
RUN CGO_ENABLED=0 GOOS=linux go build -o Generator
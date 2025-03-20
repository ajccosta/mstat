# docker build -t bpowers/mstat .
FROM golang:1.15 as builder
MAINTAINER Bobby Powers <bobbypowers@gmail.com>

WORKDIR /go/src/github.com/bpowers/mstat
COPY . .

RUN make \
 && make install PREFIX=/usr/local


FROM ubuntu:latest

COPY --from=builder /usr/local/bin/mstat /usr/local/bin/

RUN apt-get update && \
    apt-get install -y \
	    vim git \
	    make gcc automake cmake libjemalloc-dev g++

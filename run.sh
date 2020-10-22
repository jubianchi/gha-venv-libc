#!/usr/bin/env bash

for IMAGE in debian:bullseye debian:buster debian:stretch centos:8 centos:7 ubuntu:focal ubuntu:bionic ubuntu:xenial
do
    echo "Running on $IMAGE"
    docker run --rm -it \
        -v $(pwd)/entrypoint.sh:/entrypoint.sh \
        -v $(pwd)/wasmer-linux-amd64:/wasmer \
        -v $(pwd)/cowsay.wasm:/tmp/cowsay.wasm \
        --entrypoint /entrypoint.sh \
        "$IMAGE"

    STATUS=$?

    if [ $STATUS -eq 0 ]
    then
        echo "$IMAGE ✅ "
    else
        echo "$IMAGE ❌ "
    fi

    echo "------------------------------"
done


#!/usr/bin/env bash

if command -v apt-get > /dev/null 2>&1
then
    (
        apt-get update -y
        apt-get install -y binutils
    ) > /dev/null 2>&1
fi

if command -v yum > /dev/null 2>&1
then
    yum install -y binutils > /dev/null 2>&1
fi

run() {
    set -o errexit

    /wasmer/bin/wasmer compile /tmp/cowsay.wasm -o /tmp/cowsay.wjit 2>&1
    /wasmer/bin/wasmer /tmp/cowsay.wasm -- "Hello from Debian $(uname -a)" 2>&1
    /wasmer/bin/wasmer /tmp/cowsay.wjit -- "Hello from Debian $(uname -a)" 2>&1
}

ERROR=$(run)

STATUS=$?

if [ ! $STATUS -eq 0 ]
then
    echo -e "\033[1;31mErrors:\n\033[0;31m$ERROR\033[0m\n"

    echo -e "\033[1;31mProvided libraries:\033[0;31m"
    test -L /lib/x86_64-linux-gnu/libc.so.6 && strings /lib/x86_64-linux-gnu/libc.so.6 | grep -e '^GLIBC_[0-9]' | sort -V | tail -n1
    test -L /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep -e '^GLIBCXX_[0-9]' | sort -V | tail -n1

    test -L /usr/lib64/libc.so.6 && strings /usr/lib64/libc.so.6 | grep -e '^GLIBC_[0-9]' | sort -V | tail -n1
    test -L /usr/lib64/libstdc++.so.6 && strings /usr/lib64/libstdc++.so.6 | grep -e '^GLIBCXX_[0-9]' | sort -V | tail -n1
    echo -e "\033[0m"

    command -v ubuntu-support-status > /dev/null && ubuntu-support-status
fi

exit $STATUS
#!/bin/bash
file=$1
if [ -z "${file}" ]; then
    echo "file arg is not specified"
    exit 1
fi
qemu-system-i386 -drive format=raw,file=$file -display curses;


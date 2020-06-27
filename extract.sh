#!/usr/bin/env sh

# Extracts Files based on their extensions
# 'extract --clean' cleans up the archive after extraction

[ "$1" = --clean ] && shift && clean=true
path=$(readlink -f "$1")
name="${path%.*}"
ext="${path##*.}"

case $ext in
    zip) : ;;
    tar) : ;;
    rar) : ;;
esac

[ "$clean" ] &&
    :

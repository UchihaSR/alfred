#!/usr/bin/env sh

# Extracts Files based on their extensions
# 'extract --clean' cleans up the archive after extraction

[ "$1" = --clean ] && shift && clean=true
ext="${1##*.}"

case $ext in
    zip) unzip "$1" -d "${1%.*}" ;;
    tar) tar -xvf "$1" ;;
    gz) gunzip "$1" ;;
    *) exit 1 ;;
        # zip) unzip "$path" -d "${1%.*}" ;;
        # rar) unrar "$path" ;;
esac

[ "$clean" ] && rm -f "$1"

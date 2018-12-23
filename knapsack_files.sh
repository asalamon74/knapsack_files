#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage:"
    echo "  $(basename "$0") [options] directory"
    echo "Options:"
    echo "  -h, --help                  display this help"
}

error() {
    echo "$1"
    usage
    exit 1
}

for i in "$@"
do
case $i in
    -h|--help)
    usage
    exit
    ;;
    -*)
    echo "Unknown option $1"
    usage
    exit 1
    ;;
esac
done

directory=${1:-}
filesizes=()
filenames=()

[[ -z "${directory}" ]] && error "NO DIRECTORY SPECIFIED"

get_file_sizes() {
    for file in "${directory}"/*; do
        echo "$file"
        filenames+=("$file")
        filesizes+=("$(stat --printf="%s" "$file")")
    done
}

echo "Starting processing ${directory}"
get_file_sizes
echo Num items: ${#filenames[@]}
echo Data: "${filenames[@]}"
echo Num items: ${#filesizes[@]}
echo Data: "${filesizes[@]}"

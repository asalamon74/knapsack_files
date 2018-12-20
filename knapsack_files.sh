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

[[ -z "${directory}" ]] && error "NO DIRECTORY SPECIFIED"

echo "Starting processing ${directory}"

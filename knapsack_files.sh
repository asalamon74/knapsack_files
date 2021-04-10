#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage:"
    echo "  $(basename "$0") [options] directory"
    echo "Options:"
    echo "  -h, --help       display this help"
    echo "  -d, --debug      print debug messages"
    echo "  -o, --only_files print only the file names"
}

error() {
    echo "$1"
    usage
    exit 1
}

debug() {
    if [ -n "${debug}" ]; then
        echo "$1" >&2
    fi
}

debug=
only_files=

for i in "$@"
do
case $i in
    -h|--help)
    usage
    exit
    ;;
    -d|--debug)
    debug=1
    shift
    ;;
    -o|--only_files)
    only_files=1
    shift
    ;;
    -*)
    echo "Unknown option $1"
    usage
    exit 1
    ;;
esac
done

directory=${1:-}
maxsize=4700000000
filesizes=()
filenames=()
filenum=0

[[ -z "${directory}" ]] && error "NO DIRECTORY SPECIFIED"

get_file_sizes() {
    for file in "${directory}"/*; do
        if [ -f "$file" ]; then
            filenames+=("$file")
            filesizes+=("$(stat --printf="%s" "$file")")
            debug "${filenames[-1]} ${filesizes[-1]}"
        fi
    done
    filenum=${#filenames[@]}
}

save_result() {
    mmm[$1,$2]=$3
    debug  "RETURN $1 $2: $3"
}

solve_knapsack() {
    local i=$1
    local j=$2
    if [ -n "${mmm[i,j]+x}" ]; then
        return
    fi
    local temp_1
    debug "SOLVE  $i $j"
    if [[ "$i" -le 0 ]]; then
        result[$i,$j]=""
        save_result "$i" "$j" 0
        return
    fi
    if [ "$j" -le 0 ]; then
        result[$i,$j]=""
        save_result "$i" "$j" 0
        return
    fi
    local ii=$((i-1))
    solve_knapsack $ii "$j"
    temp_1=${mmm[ii,j]}
    local fsize=${filesizes[i-1]}
    local fname=${filenames[i-1]}
    local temp_2=0
    if [[ "${fsize}" -le "${j}" ]]; then
        local jj=$((j-fsize))
        solve_knapsack $ii $jj
        temp_2=$((mmm[ii, jj]+fsize))
    fi
    local max
    if [ "$temp_1" -ge "$temp_2" ]  ; then
        result[$i,$j]="${result[ii,$j]}"
        max=$temp_1
    else
        result[$i,$j]="${result[$ii,$jj]} ${fname}"
        max=$temp_2
    fi
    save_result "$i" "$j" "$max"
}

debug "Starting processing ${directory}"
get_file_sizes
debug "Found $filenum files"
solve_knapsack "$filenum" $maxsize
[[ -n "${only_files}" ]] || echo "${mmm[filenum,maxsize]}"
for file in ${result[filenum,maxsize]}; do
    echo "$file"
done

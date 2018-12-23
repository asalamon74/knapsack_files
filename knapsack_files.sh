#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage:"
    echo "  $(basename "$0") [options] directory"
    echo "Options:"
    echo "  -h, --help     display this help"
    echo "  -d, --debug    print debug messages"
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

for i in "$@"
do
case $i in
    -h|--help)
    usage
    exit
    ;;
    -d|--debug)
    debug=1
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
        filenames+=("$file")
        filesizes+=("$(stat --printf="%s" "$file")")
        debug "${filenames[-1]} ${filesizes[-1]}"
    done
    filenum=${#filenames[@]}
}

solve_knapsack() {
    local i=$1
    local j=$2
    if [ ! -z ${mmm[i,j]+x} ]; then
        return 0
    fi    
    local temp_1
    local temp_2
    debug "SOLVE  $i $j"
    if [[ "$i" -le 0 ]]; then
        mmm[$i,$j]=0
        result[$i,$j]=""
        debug "RETURN $i $j 0"
        return 0
    fi
    if [ "$j" -le 0 ]; then
        mmm[$i,$j]=0
        result[$i,$j]=""        
        debug "RETURN $i $j 0"
        return 0
    fi
    local ii=$((i-1))
    solve_knapsack $ii "$j"
    temp_1=${mmm[ii,j]}
    local fsize=${filesizes[i-1]}
    local fname=${filenames[i-1]}
    if [[ "${fsize}" -le "${j}" ]]; then        
        local jj=$((j-fsize))
        solve_knapsack $ii $jj
        temp_2=${mmm[ii, jj]}
        ((temp_2+=fsize))            
    else
        temp_2=0
    fi
    if [ $temp_1 -ge $temp_2 ]; then
        result[$i,$j]="${result[ii,$j]}"
    else
        result[$i,$j]="${result[$ii,$jj]} ${fname}"
    fi                                         
    local max=$((temp_1 > temp_2 ? temp_1 : temp_2))    
    mmm[$i,$j]=$max
    debug "RETURN $i $j $max"
}

debug "Starting processing ${directory}"
get_file_sizes
debug "Found $filenum files"
solve_knapsack "$filenum" $maxsize
echo ${mmm[filenum,maxsize]}
#echo "${result[filenum,maxsize]}"
for file in ${result[filenum,maxsize]}; do
    echo "$file"
done
            

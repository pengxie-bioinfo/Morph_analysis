#!/bin/sh

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

if [ -f "temp" ]; then rm temp; fi
if [ -f "temp_qc" ]; then rm temp_qc; fi
if [ ! -e "temp_dir" ]; then mkdir temp_dir; fi
if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi

for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    sleep 1s
    while (( $(echo "$(ps -A -o %cpu | awk '{s+=$1} END {print s}') > 300" | bc -l) ))
    do
        sleep 1s
    done
    input=$(echo ${cur_path}/processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.swc)
    output=$(echo ${cur_path}/processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed)
    echo ${input} | awk -F "/" '{print $NF}'
    while [ ! -f ${input} ]
    do
        echo ${input}
        sleep 10s
    done

    # QC
    if [ ! -f ${output}.QC.txt ]
    then
        vaa3d64 -x preprocess -f qc -p "#i ${input} #o ${output}" &
    fi
done





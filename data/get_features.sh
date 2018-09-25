#!/bin/sh

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

# Check whether all files are ready
# Compute features

for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    # 1 Dendrite
    oldfile=$(echo processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.dendrite.swc)
    while [ ! -f ${oldfile} ]
    do
        sleep 1s
        echo "waiting for" ${oldfile}
    done
    newfile=$(echo processed_swc/Dendrite/${brain_name}_${cell_type}_${cell_name}.processed.dendrite.swc)
    mv ${oldfile} processed_swc/Dendrite/
    sleep 1s
    while (( $(echo "$(ps -A -o %cpu | awk '{s+=$1} END {print s}') > 300" | bc -l) ))
    do
        sleep 1s
    done
    echo "${cell_name}\n${cell_type}" >temp_dir/${brain_name}_${cell_type}_${cell_name}.dendrite.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i ${newfile} |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${brain_name}_${cell_type}_${cell_name}.dendrite.features &

    # 2 Long projection axon
    oldfile=$(echo processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.long_axon.swc)
    while [ ! -f ${oldfile} ]
    do
        sleep 1s
        echo "waiting for" ${oldfile}
    done
    newfile=$(echo processed_swc/Axon/${brain_name}_${cell_type}_${cell_name}.processed.long_axon.swc)
    mv processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.*axon* processed_swc/Axon/
    sleep 1s
    while (( $(echo "$(ps -A -o %cpu | awk '{s+=$1} END {print s}') > 300" | bc -l) ))
    do
        sleep 1s
    done
    echo "${cell_name}\n${cell_type}" >temp_dir/${brain_name}_${cell_type}_${cell_name}.long_axon.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i ${newfile} |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${brain_name}_${cell_type}_${cell_name}.long_axon.features &

    # 3 Axon clusters: to be implemented

done


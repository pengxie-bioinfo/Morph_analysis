#!/bin/sh

#  split_neuron.sh
#  
#
#  Created by Peng Xie on 9/6/18.
#  

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

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

# 1. Prepare SWC file
cell_no=$(echo ${cell_name} | sed 's/^0*//g')
if [ -f $(find processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.dendrite.swc|head -1) ];then rm processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.dendrite.swc;fi
if [ -f $(find processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.*axon*|head -1) ];then rm processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.*axon*;fi
vaa3d64 -x preprocess -f split_neuron -p "#i ${input}" &
done

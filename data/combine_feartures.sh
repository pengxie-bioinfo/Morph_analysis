#!/bin/sh

#  combine_feartures.sh
#  
#
#  Created by Peng Xie on 9/6/18.
#  

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

# Combine dendrite results
if [ -f "temp" ]; then rm temp; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    featurefile=$(echo temp_dir/${brain_name}_${cell_type}_${cell_name}.dendrite.features)
    while [ ! -f ${featurefile} ]
    do
        sleep 1s
    done
    if [ ! -f "temp" ]; then cp link/feature.names temp; fi
    paste temp ${featurefile} > temp.shadow
    mv temp.shadow temp
done
mv temp features/${brain_name}_${cell_type}.dendrite.features

# Combine lpa results
if [ -f "temp" ]; then rm temp; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    featurefile=$(echo temp_dir/${brain_name}_${cell_type}_${cell_name}.long_axon.features)
    while [ ! -f ${featurefile} ]
    do
        sleep 1s
    done
    if [ ! -f "temp" ]; then cp link/feature.names temp; fi
    paste temp ${featurefile} > temp.shadow
    mv temp.shadow temp
done
mv temp features/${brain_name}_${cell_type}.long_axon.features

# Combine lpa results
if [ -f "temp" ]; then rm temp; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    featurefile=$(echo temp_dir/${brain_name}_${cell_type}_${cell_name}.proximal_axon.features)
    while [ ! -f ${featurefile} ]
    do
        sleep 1s
    done
    if [ ! -f "temp" ]; then cp link/feature.names temp; fi
    paste temp ${featurefile} > temp.shadow
    mv temp.shadow temp
done
mv temp features/${brain_name}_${cell_type}.proximal_axon.features

# Combine lpa results
if [ -f "temp" ]; then rm temp; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    featurefile=$(echo temp_dir/${brain_name}_${cell_type}_${cell_name}.distal_axon.features)
    while [ ! -f ${featurefile} ]
    do
        sleep 1s
    done
    if [ ! -f "temp" ]; then cp link/feature.names temp; fi
    paste temp ${featurefile} > temp.shadow
    mv temp.shadow temp
done
mv temp features/${brain_name}_${cell_type}.distal_axon.features



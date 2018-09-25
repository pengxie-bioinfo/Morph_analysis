#!/bin/sh/

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    prefix=$(echo ${brain_name}_${cell_type}_${cell_name})
    # Step 1: preprocess
    if [ ! -f processed_swc/Whole/${prefix}.processed.swc ]
    then
        cp $(find ${swc_path}/${brain_name}_${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}') temp_dir/${brain_name}_${cell_type}_${cell_name}.swc
        cell_no=$(echo ${cell_name} | sed 's/^0*//g')
        awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >temp_dir/${brain_name}_${cell_type}_${cell_name}.apo
        vaa3d64 -x preprocess -f preprocess -p "#i temp_dir/${prefix}.swc #o processed_swc/Whole/${prefix}.processed.swc #l 2 #s 0 #m 70 #t 2 #r 0 #d 0 #f 0"
    fi

    # Step 2: QC
    vaa3d64 -x preprocess -f qc -p "#i processed_swc/Whole/${prefix}.processed.swc #o processed_swc/Whole/${prefix}.processed"
    mv processed_swc/Whole/${prefix}.processed.QC.txt QC/separate_files

    # Step 3: Split
    vaa3d64 -x preprocess -f split_neuron -p "#i processed_swc/Whole/${prefix}.processed.swc"
    mv processed_swc/Whole/${prefix}.processed*axon* processed_swc/Axon/
    mv processed_swc/Whole/${prefix}.processed*dendrite* processed_swc/Dendrite/
    vaa3d64 -x preprocess -f crop_swc -p "#i processed_swc/Dendrite/${prefix}.processed.dendrite.swc #r -1 #j -1 #c 1 #t 1"
    vaa3d64 -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.long_axon.swc #r -1 #j -1 #c 1 #t 1"
    vaa3d64 -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.axon.proximal_axon.swc #r -1 #j -1 #c 1 #t 1"
    vaa3d64 -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.axon.distal_axon.swc #r -1 #j -1 #c 1 #t 1"

    # Step 4: Global features
    echo "${cell_name}\n${cell_type}" >temp_dir/${prefix}.dendrite.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/Dendrite/${prefix}.processed.dendrite.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.dendrite.features
    echo "${cell_name}\n${cell_type}" >temp_dir/${prefix}.long_axon.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.long_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.long_axon.features
    echo "${cell_name}\n${cell_type}" >temp_dir/${prefix}.proximal_axon.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.axon.proximal_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.proximal_axon.features
    echo "${cell_name}\n${cell_type}" >temp_dir/${prefix}.distal_axon.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.axon.distal_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.distal_axon.features

done

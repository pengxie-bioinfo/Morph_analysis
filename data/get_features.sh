#!/bin/sh

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

if [ -f "temp" ]; then rm temp; fi
if [ -f "temp_qc" ]; then rm temp_qc; fi
if [ ! -e "temp_dir" ]; then mkdir temp_dir; fi
if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi

#for cell_name in $(find ${swc_path}/*swc | awk -F "/" '{print $9}'|awk -F "_" '{print $1}'|sort -u |head -1)
for cell_name in $(find ${swc_path}/*swc | awk -F "/" '{print $9}'|awk -F "_" '{print $1}'|sort -u)
do

    # 1. Prepare SWC file
	cell_no=$(echo ${cell_name} | sed 's/^0*//g')
    echo $(find ${swc_path}/${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}')
    cp $(find ${swc_path}/${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}') temp_dir/${cell_type}_${cell_name}.swc
    awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >temp_dir/${cell_type}_${cell_name}.apo
    vaa3d64 -x preprocess -f preprocess -p "#i ${cur_path}/temp_dir/${cell_type}_${cell_name}.swc #o ${cur_path}/processed_swc/${cell_type}_${cell_name}.processed.swc #l 2 #s 0 #m 2000 #t 0.25 #r 0 #d 0 #f 1"


    # 2. Compute features
    # 2.1 Check column names
    if [ ! -f "feature.names" ]
        then
            echo -e "ID\nType" >feature.names
            /home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/${cell_type}_${cell_name}.processed.dendrite.swc |grep ":" | awk -F ":" '{print $1}' >>feature.names
    fi
    if [ ! -f "QC_stats.names" ]
    then
        echo -e "ID\nType" >QC_stats.names
        awk '{print $1}' ${cur_path}/processed_swc/${cell_type}_${cell_name}.processed.QC.txt>>QC_stats.names
    fi

    # 2.1 Run
    # 2.1.1 Dendrite
    echo "${cell_name}\n${cell_type}" >temp_dir/${cell_type}_${cell_name}.dendrite.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/${cell_type}_${cell_name}.processed.dendrite.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${cell_type}_${cell_name}.dendrite.features

    # 2.1.2 Long projection axon
    echo "${cell_name}\n${cell_type}" >temp_dir/${cell_type}_${cell_name}.long_axon.features
    vaa3d64 -x global_neuron_feature -f compute_feature -i processed_swc/${cell_type}_${cell_name}.processed.long_axon.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${cell_type}_${cell_name}.long_axon.features

    # 2.1.3 Axon clusters: to be implemented

    # 2.1.4 QC
    echo "${cell_name}\n${cell_type}" >${cur_path}/temp_dir/${cell_type}_${cell_name}.processed.QC.header
    cut -f 2 ${cur_path}/processed_swc/${cell_type}_${cell_name}.processed.QC.txt | cat ${cur_path}/temp_dir/${cell_type}_${cell_name}.processed.QC.header - >${cur_path}/temp_dir/${cell_type}_${cell_name}.processed.QC

    # 3. Combine results
    if [ ! -f "temp_lpa" ]; then cp feature.names temp_lpa; fi
    if [ ! -f "temp_ddt" ]; then cp feature.names temp_ddt; fi
    if [ ! -f "temp_qc" ]; then cp QC_stats.names temp_qc; fi
#    if [ $(wc -l temp_dir/${cell_type}_${cell_name}.${component_name}.features|awk '{print $1}') -gt 2 ]
    if [ $(tail -1 ${cur_path}/temp_dir/${cell_type}_${cell_name}.processed.QC | sed "s/\%//") > 20 ]
    then
        paste temp_ddt temp_dir/${cell_type}_${cell_name}.dendrite.features > temp_ddt.shadow
        paste temp_lpa temp_dir/${cell_type}_${cell_name}.long_axon.features > temp_lpa.shadow
        paste temp_qc ${cur_path}/temp_dir/${cell_type}_${cell_name}.processed.QC > temp_qc.shadow
    fi
    mv temp_ddt.shadow temp_ddt
    mv temp_lpa.shadow temp_lpa
    mv temp_qc.shadow temp_qc

done
#rm -r temp_dir
mv temp_ddt ${brain_name}_${cell_type}.dendrite.features
mv temp_lpa ${brain_name}_${cell_type}.long_axon.features
mv temp_qc ${brain_name}_${cell_type}.QC.txt


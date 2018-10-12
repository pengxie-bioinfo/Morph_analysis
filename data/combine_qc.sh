#!/bin/sh

#  qc_combine.sh
#  
#
#  Created by Peng Xie on 9/6/18.
#  

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $10}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
    qcfile=$(echo ${cur_path}/QC/separate_files/${brain_name}_${cell_type}_${cell_name}.processed.QC.txt)
    while [ ! -f ${qcfile} ]
    do
        sleep 5s
        echo "waiting for "${qcfile}
    done

    echo "${cell_name}\n${cell_type}" >${cur_path}/temp_dir/${brain_name}_${cell_type}_${cell_name}.processed.QC.header
    echo "cut -f 2" ${qcfile}
    cut -f 2 ${qcfile} | cat ${cur_path}/temp_dir/${brain_name}_${cell_type}_${cell_name}.processed.QC.header - > ${cur_path}/temp_dir/${brain_name}_${cell_type}_${cell_name}.processed.QC

# Combine results
if [ ! -f "temp_qc" ]; then cp link/QC_stats.names temp_qc; fi
paste temp_qc ${cur_path}/temp_dir/${brain_name}_${cell_type}_${cell_name}.processed.QC > temp_qc.shadow
mv temp_qc.shadow temp_qc
done

mv temp_qc QC/${brain_name}_${cell_type}.QC.txt

#!/bin/sh

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})
cur_path=$(pwd)

if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $9}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do

    # 1. Prepare SWC file
	cell_no=$(echo ${cell_name} | sed 's/^0*//g')
#    echo $(find ${swc_path}/${brain_name}_${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}'|awk -F "/" '{print $NF}')
    input=$(echo ${cur_path}/temp_dir/${brain_name}_${cell_type}_${cell_name}.swc)
    output=$(echo ${cur_path}/processed_swc/Whole/${brain_name}_${cell_type}_${cell_name}.processed.swc)
    if [ ! -e ${output} ]
    then
        sleep 1s
        echo ${input} | awk -F "/" '{print $NF}'
        # Input files
        cp $(find ${swc_path}/${brain_name}_${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}') temp_dir/${brain_name}_${cell_type}_${cell_name}.swc
        awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >temp_dir/${brain_name}_${cell_type}_${cell_name}.apo
        # Run
        while (( $(echo "$(ps -A -o %cpu | awk '{s+=$1} END {print s}') > 300" | bc -l) ))
#        while (( $(echo "$(ps -ax | grep -i vaa3d64 |grep -v grep|wc -l) > 4" |bc -l) ))
        do
            echo $(ps -A -o %cpu | awk '{s+=$1} END {print "CPU usage:\t",s,"%"}')
            sleep 1s
        done
        vaa3d64 -x preprocess -f preprocess -p "#i ${input} #o ${output} #l 2 #s 0 #m 70 #t 5 #r 0 #d 0 #f 0" &
    fi
done

#rm ${cur_path}/processed_swc/Whole/*temp.swc


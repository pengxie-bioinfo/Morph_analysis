#!/bin/sh

source ./config.conf
swc_path=$(echo ${swc_prefix}${cell_type})


if [ -f "temp" ]; then rm temp; fi
if [ ! -e "temp_dir" ]; then mkdir temp_dir; fi
if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi

for cell_name in $(find ${swc_path}/*swc | awk -F "/" '{print $9}'|awk -F "_" '{print $1}'|sort -u)
do
	cell_no=$(echo ${cell_name} | sed 's/^0*//g')
	# 1. Prepare SWC file
	awk -v x=${component_no} '{if($2==x)print $0}' $(find ${swc_path}/${cell_name}*swc |awk '{if(NR==1)print $1}') >temp_dir/${cell_type}_${cell_name}.${component_name}.swc
	awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >temp_dir/${cell_type}_${cell_name}.${component_name}.apo
	#/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x sort_neuron_swc_lmg -f sort_swc_lmg -i temp_dir/${cell_type}_${cell_name}.${component_name}.swc -o processed_swc/${cell_type}_${cell_name}.${component_name}.sorted.swc -p 1000
	vaa3d -x preprocess -f preprocess -p "#i temp_dir/${cell_type}_${cell_name}.${component_name}.swc #o processed_swc/${cell_type}_${cell_name}.${component_name}.sorted.swc #l 3 #s 0 #t 2 #r 1"
	# 1.1 Check column names
	if [ ! -f "feature.names" ]
		then
			echo -e "ID\nType" >feature.names
			/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/${cell_type}_${cell_name}.${component_name}.sorted.swc |grep ":" | awk -F ":" '{print $1}' >>feature.names
	fi

	# 2. Compute features
	echo -e "${cell_name}\n${cell_type}" >temp_dir/${cell_type}_${cell_name}.${component_name}.features
	/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/${cell_type}_${cell_name}.${component_name}.sorted.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${cell_type}_${cell_name}.${component_name}.features

	# 3. Combine results
	if [ ! -f "temp" ]; then cp feature.names temp; fi
	if [ $(wc -l temp_dir/${cell_type}_${cell_name}.${component_name}.features|awk '{print $1}') -gt 2 ];then paste temp temp_dir/${cell_type}_${cell_name}.${component_name}.features > temp.shadow;fi
	mv temp.shadow temp;
done
#rm -r temp_dir
mv temp ${brain_name}_${cell_type}.${component_name}.features


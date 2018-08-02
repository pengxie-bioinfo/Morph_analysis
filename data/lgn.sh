#!/bin/sh
component_name="dendrite"
component_no=3
cell_type="LGN"
swc_path=$(echo "/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_"${cell_type})
soma_path="/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo"

if [ -f "temp" ]; then rm temp; fi
for cell_name in $(find ${swc_path}/*swc | awk -F "/" '{print $9}'|awk -F "_" '{print $1}')
do
cell_no=$(echo ${cell_name} | sed 's/^0*//g')
# 1. Prepare SWC file
awk -v x=${component_no} '{if($2==x)print $0}' $(find ${swc_path}/${cell_name}*swc) >${cell_type}_${cell_name}.${component_name}.swc
awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >${cell_type}_${cell_name}.${component_name}.apo
/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x sort_neuron_swc_lmg -f sort_swc_lmg -i ${cell_type}_${cell_name}.${component_name}.swc -o ${cell_type}_${cell_name}.${component_name}.sorted.swc -p 1000

# 1.1 Check column names
if [ ! -f "feature.names" ]
then
echo -e "ID\nType" >feature.names
/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x global_neuron_feature -f compute_feature -i ${cell_type}_${cell_name}.${component_name}.sorted.swc |grep ":" | awk -F ":" '{print $1}' >>feature.names
fi

# 2. Compute features
echo -e "${cell_name}\n${cell_type}" >${cell_type}_${cell_name}.${component_name}.features
/home/penglab/Desktop/vaa3d/v3d_external/bin/vaa3d -x global_neuron_feature -f compute_feature -i ${cell_type}_${cell_name}.${component_name}.sorted.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>${cell_type}_${cell_name}.${component_name}.features

# 3. Combine results
if [ ! -f "temp" ]; then cp feature.names temp; fi
if [ $(wc -l ${cell_type}_${cell_name}.${component_name}.features|awk '{print $1}') -gt 2 ];then paste temp ${cell_type}_${cell_name}.${component_name}.features > temp.shadow;fi
mv temp.shadow temp;
rm ${cell_type}_${cell_name}*
done

mv temp ${cell_type}.features


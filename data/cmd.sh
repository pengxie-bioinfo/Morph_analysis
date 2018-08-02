#!/bin/sh
component_name="dendrite"
component_no=3
cell_type="CPU"
swc_path=$(echo "/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_"${cell_type})
soma_path="/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo"

sh get_features.sh

cell_type="LGN"
swc_path=$(echo "/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_"${cell_type})
soma_path="/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo"

sh get_features.sh



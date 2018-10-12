#!/bin/sh

#  17302_cmd_new.sh
#  
#
#  Created by Peng Xie on 9/9/18.
#  

if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi
if [ ! -e "processed_swc/Whole" ]; then mkdir processed_swc/Whole; fi
if [ ! -e "processed_swc/Axon" ]; then mkdir processed_swc/Axon; fi
if [ ! -e "processed_swc/Dendrite" ]; then mkdir processed_swc/Dendrite; fi
if [ ! -e "temp_dir" ]; then mkdir temp_dir; fi

# 17302_CPU
echo "brain_name=17302
cell_type=\"CPU\"
swc_prefix=\"../../SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"../../SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh

# 17302_LGN
echo "brain_name=17302
cell_type=\"LGN\"
swc_prefix=\"../../SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"../../SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh

# 17302_Thalamuscells
echo "brain_name=17302
cell_type=\"Thalamuscells\"
swc_prefix=\"../../Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"../../Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh


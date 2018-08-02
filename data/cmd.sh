#!/bin/sh

####################################################################################################################################################
# 17302_LGN
####################################################################################################################################################

echo "component_name=\"dendrite\"
component_no=3
cell_type=\"LGN\"
swc_prefix=\"/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

sh get_features.sh

####################################################################################################################################################
# 17302_CPU
####################################################################################################################################################

echo "component_name=\"dendrite\"
component_no=3
cell_type=\"CPU\"
swc_prefix=\"/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/home/penglab/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

sh get_features.sh




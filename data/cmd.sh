#!/bin/sh

####################################################################################################################################################
# 17302_LGN
####################################################################################################################################################

echo "brain_name=17302
cell_type=\"LGN\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features.sh >${cell_type}.${brain_name}.log


####################################################################################################################################################
# 17302_CPU
####################################################################################################################################################

echo "brain_name=17302
cell_type=\"CPU\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features.sh >${cell_type}.${brain_name}.log
















####################################################################################################################################################
# 17302_LGN
####################################################################################################################################################

echo "component_name=\"dendrite\"
component_no=3
component_tag=\"d\"
component_name=\"dendrite\"
brain_name=17302
cell_type=\"LGN\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features.sh >${cell_type}.${component_name}.${brain_name}.log

echo "component_name=\"axon\"
component_no=2
component_tag=\"a\"
component_name=\"axon\"
brain_name=17302
cell_type=\"LGN\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features_axon.sh >${cell_type}.${component_name}.${brain_name}.log


####################################################################################################################################################
# 17302_CPU
####################################################################################################################################################

echo "component_name=\"dendrite\"
component_no=3
component_tag=\"d\"
component_name=\"dendrite\"
brain_name=17302
cell_type=\"CPU\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features.sh >${cell_type}.${component_name}.${brain_name}.log

echo "component_name=\"axon\"
component_no=2
component_tag=\"a\"
component_name=\"axon\"
brain_name=17302
cell_type=\"CPU\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17302_Finished_Neurons/17302_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/124_somas_markers/somas.ano.apo\"" >config.conf

source ./config.conf
sh get_features_axon.sh >${cell_type}.${component_name}.${brain_name}.log



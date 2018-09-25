#!/bin/sh

#  17545_cmd_new.sh
#  
#
#  Created by Peng Xie on 9/10/18.
#  

#!/bin/sh

#  17545_cmd_new.sh
#
#
#  Created by Peng Xie on 9/9/18.
#
if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi
if [ ! -e "processed_swc/Whole" ]; then mkdir processed_swc/Whole; fi
if [ ! -e "processed_swc/Axon" ]; then mkdir processed_swc/Axon; fi
if [ ! -e "processed_swc/Dendrite" ]; then mkdir processed_swc/Dendrite; fi
if [ ! -e "temp_dir" ]; then mkdir temp_dir; fi

# 17545_CPU
echo "brain_name=17545
cell_type=\"CPU\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_Finished_Neurons/17545_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_soma_list/soma_list.ano.apo\"" >config.conf
sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh

# 17545_LGN
echo "brain_name=17545
cell_type=\"LGN\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_Finished_Neurons/17545_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_soma_list/soma_list.ano.apo\"" >config.conf
sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh

# 17545_Thalamuscells
echo "brain_name=17545
cell_type=\"Thalamuscells\"
swc_prefix=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_Finished_Neurons/17545_\"
soma_path=\"/Users/pengxie/Documents/SEUAllenJointDataCenter/finished_annotations/17545_soma_list/soma_list.ano.apo\"" >config.conf
sh one_swc_pipeline.sh
sh combine_qc.sh
sh combine_feartures.sh


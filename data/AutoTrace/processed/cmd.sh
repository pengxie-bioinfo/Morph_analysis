for i in $(find /local1/Documents/Morph_analysis/data/temp_dir/17302*swc)
do
	id=$(echo ${i} | awk -F "/" '{print $7}' |awk -F "_" '{print $3}' |awk -F "." '{print $1}')
	echo ${id}
	if [ ! -f ${id}.swc ]
	then
		echo "Run preprocess"
		vaa3d -x preprocess -f preprocess -p "#i ${i} #o ./${id}.swc #s 2 #t 2 #l 5 #m 70"
	fi
	if [ -e ${id} ]
	then
		rm -r ${id}
	fi
	mkdir ${id}
	vaa3d -x preprocess -f check_connection -p "#i ${id}.swc #c ${id}.new_connection.swc #t /fmost/fmost-data/fMOST_terafly/mouseID_321237-17302/RES(54600x34412x9847) #o ${id}"
	#vaa3d -x calculate_reliability_score -f calculate_score_terafly -i '/fmost/fmost-data/fMOST_terafly/mouseID_321237-17302/RES(54600x34412x9847)' ${id}.new_connection.swc -o ${id}.confidence.swc -p 1 2
#	vaa3d -x preprocess -f crop_swc -p "#i ${i} #o ./${id}.cropped.swc #r 200 #c 0 #a 1"
done  

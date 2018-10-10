for i in $(find *auto_3.swc)
do
	id=$(echo ${i} | awk -F "." '{print $1}')
	echo ${i}
	echo ${id}
	vaa3d -x preprocess -f crop_swc -p "#i ${i} #o ${id}.cropped.swc #r 200 #c 0 #a 1"
done	

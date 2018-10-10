find /data/mat/zhi/whole_mouse/mouseID_321237-17302/17302_auto_7th/*ano |sed 's/\.ano//'|awk -F "/" '{print $8}' >id_list.txt
cp distance.index distance.csv
for i in $(cat id_list.txt |head -1)
do
	if [ -f ../processed/${i}*cropped*swc ]
	then
		x=$(find ../auto_3/${i}*cropped*swc)
		y=$(find ../processed/${i}*cropped*swc)
		echo ${x} | awk 'BEGIN{OFS=""}{print "SWCFILE=",$0}' >${i}.ano
        	echo ${y} | awk 'BEGIN{OFS=""}{print "SWCFILE=",$0}' >>${i}.ano
		vaa3d -x neuron_distance -f neuron_distance -i ${x} ${y} -p 10 -o tp
		awk -F "= " '{print $2}' tp |paste -d "," distance.csv - >distance.csv.shadow
		mv distance.csv.shadow distance.csv
	fi
done
rm tp

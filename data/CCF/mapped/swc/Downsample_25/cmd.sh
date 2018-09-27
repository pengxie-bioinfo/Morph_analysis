ratio=25
for i in $(find ../raw/*swc |awk -F "/" '{print $3}' )
do
echo ${i}
awk -F " " -v r=${ratio} '{if(/#/)print $0;else print $1,$2,$3/r,$4/r,$5/r,$6,$7}' ../raw/${i} >${i}_${ratio}.swc
done

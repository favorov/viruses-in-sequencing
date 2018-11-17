#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
. /etc/profile.d/modules.sh
module load sharedapps

manif=data/manifest
data=data

for xml in $manif/*.xml 
do
	xmlfilename=$(basename "$xml")
	xmlname=${xmlfilename%.*}
	#echo $xmlname
	mkdir -p ${data}/$xmlname
	~/cghub/bin/gtdownload -d $xml -c cghub.key -p ${data}/$xmlname 
done

#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh

module load sharedapps
module load python2.7/2.7.6
module load bowtie/1.1.1


folder=${folder-$1}
#folder is to be passed by -v option to qsub or set by other method
#if it is not, we try ${1}
[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder
#folder is to exist on that stage

#scripthome=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )
#it works only if script is started not by qrsh
scripthome=${scripthome-${2-~/viruses-in-RNA-seq}}

chimereref=$scripthome/Chimeric.Genomes/hg19+HPV+EBV
indexname=hg19+hpv+ebv
mapsplice=~/Mapsplice/MapSplice-v2.2.0/mapsplice.py

echo "started looking for HPV and EBV in folder $folder"

if [ ! -f $folder/timestamp.mapsplice.unmapped.stop.txt ]
then
	pushd $folder > /dev/null
	
	touch timestamp.mapsplice.unmapped.start.txt
	
	mkdir -p virus-findings
	#if not exists, create, otherwise, do nothing, no error

	python2 $mapsplice --fusion-non-canonical -o virus-findings/ -c $chimereref -x $chimereref/$indexname -1 unmapped1.fq -2 unmapped2.fq 

	touch timestamp.mapsplice.unmapped.stop.txt

	echo 'done..' 
	popd > /dev/null 
else
	echo 'It was already done before..'
fi


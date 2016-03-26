#!/bin/bash
##$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load samtools
module load bowtie/1.1.1 

folder=${folder-$1}
#folder is to be passed by -v option to qsub or set by other method
#if it is not, we try ${1}
[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder

echo "Extracting viral from color single-end solid reads. Folder is ${folder}"
if [ ! -f ${folder}timestamp.extract.hpv.from.cfasta.completed.txt ]
then
	echo "Started..."
	#folder is to exist at that moment
	touch ${folder}/timestamp.extract.hpv.from.cfasta.started.txt	
	pushd ${folder} >/dev/null
	cfasta=`ls -m *csfasta | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g'`
	qual=`ls -m *QV.qual | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g'`
	#ln -m output all via comma
	#sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g
	#is magic sytaxis or replacing \n's 
	#http://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed

	ref=~/viruses-in-sequencing/genomes/Viral.Genomes/HPV/colour/hpv

	bowtie -S -C -f -Q $qual $ref $cfasta | samtools view -Sh -F4 - > viral-reads.sam 
	popd > /dev/null 
	touch ${folder}/timestamp.extract.hpv.from.cfasta.completed.txt	
	echo 'done..'
else
	echo 'It was already done before..'
fi

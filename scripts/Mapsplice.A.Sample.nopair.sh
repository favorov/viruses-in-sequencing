#$ -q largememory 
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -l mem_free=6G,h_vmem=12G


. /etc/profile.d/modules.sh

module load sharedapps
module load python2.7/2.7.6
module load bowtie/1.1.1


fasta=${fasta-$1}
#fasta is to be passed by -v option to qsub or set by other method
#if it is not, we try ${1}
folder=${folder-${2-.}}
#[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder
#folder is to exist on that stage

#scripthome=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )
#it works only if script is started not by qrsh
scripthome=${scripthome-${3-${HOME}/viruses-in-sequencing}}

chimereref=${scripthome}/genomes/Chimeric.Genomes/hg19+HPV16
indexname=hg19+hpv16
mapsplice=~/Mapsplice/MapSplice-v2.2.0/mapsplice.py

echo "started looking for HPV16 in $folder/$fasta"
echo "ref is in $chimereref"
echo "index is in $chimereref/$indexname"

if [ ! -f $folder/timestamp.mapsplice.${fasta}.stop.txt ]
then
	pushd $folder > /dev/null
	
	touch timestamp.mapsplice.${fasta}.start.txt
	
	mkdir -p virus-findings
	#if not exists, create, otherwise, do nothing, no error

	python2 $mapsplice --fusion --fusion-non-canonical -o virus-findings/ -c $chimereref -x $chimereref/$indexname -1 ${fasta} 

	touch timestamp.mapsplice.${fasta}.stop.txt

	echo 'done..' 
	popd > /dev/null 
else
	echo 'It was already done before..'
fi


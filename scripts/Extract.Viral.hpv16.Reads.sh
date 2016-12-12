#$ -q zappa
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load samtools
module load bedtools

folder=${folder-$1}
#folder is to be passed by -v option to qsub or set by other method
#if it is not, we try ${1}
[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder
echo "extracting viral reads, simplest way; the work folder is ${folder}virus-findings"
if [ ! -f ${folder}timestamp.extract.viral.reads.stop.txt ]
then
	#it is to exist at that moment
	pushd ${folder}virus-findings >/dev/null
	touch ../timestamp.extract.viral.reads.start.txt
	samtools view -Sbh alignments.sam > alignments.bam
	#sort to be indexed
	samtools sort alignments.bam  alignments.sorted
	#index to get subset
	samtools index alignments.sorted.bam
	#getting subset
	samtools view -bh -o viral_reads.bam alignments.sorted.bam hpv16
	touch ../timestamp.extract.viral.reads.stop.txt
	popd > /dev/null 
	echo 'done..'
else
	echo 'It was already done before..'
fi

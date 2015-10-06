#$ -q zbatch
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
	#samtools view -bh alignments.bam > alignments.bam
	#samtools index alignments.bam
	echo 1
	samtools sort alignments.bam  alignments.sorted
	echo 2
	samtools index alignments.sorted.bam 
	echo 3
	samtools view -bh -o viral_reads.bam alignments.sorted.bam hpv16 hpv33 hpv35 hhv4 hhv4t1
	touch ../timestamp.extract.viral.reads.stop.txt
	popd > /dev/null 
	echo 'done..'
else
	echo 'It was already done before..'
fi

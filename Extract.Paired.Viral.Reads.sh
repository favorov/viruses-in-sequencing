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

#scripthome=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )
#it works only if script is started not by qrsh
#scripthome=${scripthome-${2-~/viruses-in-RNA-seq}}

if [ ! -f ${folder}timestamp.extract.viral.reads.stop.txt ]
then
	echo 'the Extract.Viral.Reads.sh script was not run here, run it first'
	exit 1
fi
echo "extracting paired viral reads, simplest way; the work folder is ${folder}virus-findings"
if [ ! -f ${folder}timestamp.extract.pairred.viral.reads.stop.txt ]
then
	#it is to exist at that moment
	touch ../timestamp.extract.paired.viral.reads.start.txt
	pushd ${folder}virus-findings >/dev/null
	samtools view viral_reads.bam |  cut -f1 | sort > viral_read.ids
	#samtools view -h viral_reads.bam | grep -v -F XF: > viral_reads_no_fus.sam 
	#cat viral_reads_no_fus.sam | cut -f1 | sort > viral_read.ids
	#we take all the viral reads
	#perl ${scripthome}/kill.ids.pairs.pl viral_read.ids > unpaired_viral_read.ids
	#and, find those that do not have a pair
 	LC_ALL=C grep -w -F -f viral_read.ids alignments.sam > viral_reads_with_mates_and_fusions.sam
	#and extract all the reads with this ids form the chimeric-alignment sam file
	#samtools view -bh -o viral_reads.bam alignments.sorted.bam hpv16 hpv33 hpv35 hhv4 hhv4t1
	grep -F XF: viral_reads_with_mates_and_fusions.sam | cut -f1 | sort | uniq > viral_fusion_read.ids
	#get fusion read ids
	grep -v -w -R -f viral_fusion_read.ids viral_reads_with_mates_and_fusions.sam > viral_reads_with_mates.sam
	#remove lines with the fusion ids 
	touch ../timestamp.extract.paired.viral.reads.stop.txt
	popd > /dev/null 
	echo 'done..'
else
	echo 'It was already done before..'
fi

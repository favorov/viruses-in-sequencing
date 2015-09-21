#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load samtools
module load bedtools

source_folder=${1}
[[ ! $source_folder = *\/ ]] && source_folder=${source_folder}/
#if source_folder is not given with / add it
alignemntssam=${source_folder}alignments.sam

folder=${2}
[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder

echo "started looking for unmapped; the source folder is $source_folder; the work folder is $folder"

if [! -f $folder/unmapped-search-intermediates/GetUnmappeReads.sample.stop.timestamp.txt ]
then
	mkdir -p $folder
	#if not exists, create, otherwise, do nothing, no error

	pushd $folder >/dev/null

	touch GetUnmappeReads.sample.start.timestamp.txt

	# extract unmapped reads
	samtools view -bhS -f 4 -F 256  $alignemntssam> unmapped4.unsorted.bam

	# sort bam file
	samtools sort -n unmapped4.unsorted.bam unmapped4
	#clean
	unlink unmapped4.unsorted.bam
	# extract reads with unmapped mate
	samtools view -bhS -f 8 -F256 $alignemntssam > unmapped8.unsorted.bam

	# sort bam file
	samtools sort -n unmapped8.unsorted.bam unmapped8
	#clean
	unlink unmapped8.unsorted.bam

	#merge them
	samtools merge -n unmapped.bam unmapped4.bam unmapped8.bam
	#clean
	unlink unmapped4.bam unmapped8.bam
	#leave uniq lines only and stripe /1 and /2 at the ends of the names _after_ that 
	#the crazy sed sequnce is: for anyn ninspace sequence in the begin of the line, stripe /1 or /2
	#just striping all /1 and /2 is worse, it can be in quality string
	samtools view -h unmapped.bam | uniq |  sed -e 's/\/[12]//' > uniunmapped.sam
	#clean
	unlink unmapped.bam
	samtools view -Sb uniunmapped.sam > uniunmapped.bam
	#clean
	unlink uniunmapped.sam 

	# convert to fastq files for paired end reads to run mapsplice
	bedtools bamtofastq -i uniunmapped.bam -fq unmapped1.fq -fq2 unmapped2.fq 2> bamtofastq.err 

	# run mapsplice
	# model after Mapsplice_Sample.sh
	# get counts

	mkdir unmapped-search-intermediates
	touch GetUnmappeReads.sample.stop.timestamp.txt
	mv uniunmapped.bam bamtofastq.err GetUnmappeReads.sample.*.timestamp.txt unmapped-search-intermediates

	popd > /dev/null 

	echo 'done..'
else
	echo 'It was already done before..'
fi

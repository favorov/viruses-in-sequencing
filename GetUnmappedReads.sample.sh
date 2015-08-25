#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load samtools
module load bedtools

folder=${1-'./DGay10-26144'}

pushd $folder

echo "started looking for unmapped in folder $folder"

touch GetUnmappeReads.sample.start.timestamp.txt

# extract unmapped reads
samtools view -bhS -f 4 -F 256 alignments.sam > unmapped4.unsorted.bam

# sort bam file
samtools sort -n unmapped4.unsorted.bam unmapped4

# extract reads with unmapped mate
samtools view -bhS -f 8 -F256 alignments.sam > unmapped8.unsorted.bam

# sort bam file
samtools sort -n unmapped8.unsorted.bam unmapped8

#merge them
samtools merge -n unmapped.bam unmapped4.bam unmapped8.bam

#leave uniq lines only and stripe /1 and /2 at the ends of the names _after_ that 
#the crazy sed sequnce is: for anyn ninspace sequence in the begin of the line, stripe /1 or /2
#just striping all /1 and /2 is worse, it can be in quality string
samtools view -h unmapped.bam | uniq |  sed -e 's/\/[12]//' > uniunmapped.sam
samtools view -Sb uniunmapped.sam > uniunmapped.bam


# convert to fastq files for paired end reads to run mapsplice
bedtools bamtofastq -i uniunmapped.bam -fq unmapped1.fq -fq2 unmapped2.fq 2> bamtofastq.err 

# run mapsplice
# model after Mapsplice_Sample.sh
# get counts

mkdir unmapped-search-intermediates
touch GetUnmappeReads.sample.stop.timestamp.txt
mv un*am bamtofastq.err GetUnmappeReads.sample.*.timestamp.txt unmapped-search-intermediates

echo 'done..' 
popd > /dev/null 

#!/bin/bash
#$ -S /bin/sh
#zappa likes to say it is sh, the difference is in initialisation of evironment
#$ -q zappa
#$ -cwd
#$ -pe zappa-pe 8
#$ -j y

echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hg38+hpv16.sh $wgs1 $iter $outputdir $reference $sample"

module load bwa
module load samtools/1.6.0

pe=8
pe_1=$(expr $pe - 1)

outputdir=${outputdir%/} #removes enline / if it is there 

outwgs="${outputdir}/${sample}_${iter}"

stampdir=${outputdir}/stamps

echo "Aligning $wgs1 and $wgs2 against $reference (pair $iter), then sort and index, output to ${outwgs}.bam, stamps to $stampdir"

if [[ ! -d $stampdir ]]
then
	mkdir $stampdir 2> /dev/null || stampdir=$outputdir
fi

stamp=${stampdir}/align.${sample}_${iter}.against.hg38+hpv16

wgs2=${wgs1/_1.fq/_2.fq}

touch ${stamp}.start

if [ ! -f ${stamp}.aligned ]
then
	touch ${stamp}.aligner.started
	echo "bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 > $outwgs.sam"
	bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 > $outwgs.sam && touch ${stamp}.aligned
else
	echo "alignment was done before"
fi

if [ ! -f ${stamp}.bammed ]
then
	touch ${stamp}.bammer.started
	echo "samtools view -b -1 -@$pe_1 -o $outwgs.unsorted.bam $outwgs.sam "
	samtools view -b -1 -@$pe_1 -o $outwgs.unsorted.bam $outwgs.sam && touch ${stamp}.bammed
else
	echo "sam->bam was done before"
fi


if [ ! -f ${stamp}.sorted ]
then
	touch ${stamp}.sorter.started
	echo "samtools sort -@$pe_1 -o $outwgs.bam -l 9 $outwgs.unsorted.bam"
	samtools sort -@$pe_1 -o $outwgs.bam -l 9 $outwgs.unsorted.bam && touch ${stamp}.sorted
else
	echo "bam was sorted before"
fi

if [ ! -f ${stamp}.indexed ]
then
	#@ means treads in sort (default 1) and additional threads in index (default 0)
	touch ${stamp}.indexer.started
	echo "samtools index -@$pe_1 $outwgs.bam"
	samtools index -@$pe_1 $outwgs.bam && touch ${stamp}.indexed
else
	echo "bam was indexed before"
fi

touch ${stamp}.end
time0=`stat -c %X  ${stamp}.start`
time1=`stat -c %X  ${stamp}.end`
seconds=$( expr $time1 - $time0 )
echo "done in ${seconds} seconds"


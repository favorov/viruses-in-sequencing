#This is a spript that align by BWA mem against the reference with the name $tag + convert to BAM + sort + index one pair of wgs fastq files
#it is supposed to be invoked in module lunux + SGE evironment by calling qsub from the bwa_mem_WGS.sh script
#(c) 2020 Mera Mukhina, Alexander Favorov
#!/bin/bash
#$ -S /bin/sh
#zappa likes to say it is sh, the difference is in initialisation of evironment
#$ -q zappa
#$ -cwd
#$ -pe zappa-pe 8
#$ -o reports
#$ -j y


echo "qsub run_bwa_mem_WGS_${tag}.sh $wgs1 $iter $outputdir $reference $sample"

module load bwa
module load samtools/1.6.0

pe=8
pe_1=$(expr $pe - 1)

outputdir=${outputdir%/} #removes enline / if it is there 

outwgs="${outputdir}/${sample}_${iter}"

stampdir=${outputdir}/stamps

echo "Aligning $wgs1 and $wgs2 against $reference (pair $iter), then sort and index, output to ${outwgs}.bam, stamps to ${stampdir}, name tag is ${tag}"

if [[ ! -d $stampdir ]]
then
	mkdir $stampdir 2> /dev/null || stampdir=$outputdir
fi

stamp=${stampdir}/align.${sample}_${iter}.against.${tag}

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
echo "aligning took $( expr `stat -c %X  ${stamp}.aligned` - `stat -c %X  ${stamp}.aligner.started` ) seconds"

if [ ! -f ${stamp}.bammed ]
then
	touch ${stamp}.bammer.started
	echo "samtools view -b -1 -@$pe_1 -o $outwgs.unsorted.bam $outwgs.sam "
	samtools view -b -1 -@$pe_1 -o $outwgs.unsorted.bam $outwgs.sam && touch ${stamp}.bammed
	unlink $outwgs.sam
else
	echo "sam->bam was done before"
fi
echo "bamming took $( expr `stat -c %X  ${stamp}.bammed` - `stat -c %X  ${stamp}.bammer.started` ) seconds"


if [ ! -f ${stamp}.sorted ]
then
	touch ${stamp}.sorter.started
	echo "samtools sort -@$pe_1 -o $outwgs.bam -l 9 $outwgs.unsorted.bam"
	samtools sort -@$pe_1 -o $outwgs.bam -l 9 $outwgs.unsorted.bam && touch ${stamp}.sorted
	unlink $outwgs.unsorted.bam
else
	echo "bam was sorted before"
fi
echo "sorting took $( expr `stat -c %X  ${stamp}.sorted` - `stat -c %X  ${stamp}.sorter.started` ) seconds"

if [ ! -f ${stamp}.indexed ]
then
	#@ means treads in sort (default 1) and additional threads in index (default 0)
	touch ${stamp}.indexer.started
	echo "samtools index -@$pe_1 $outwgs.bam"
	samtools index -@$pe_1 $outwgs.bam && touch ${stamp}.indexed
else
	echo "bam was indexed before"
fi
echo "indexing took $( expr `stat -c %X  ${stamp}.indexed` - `stat -c %X  ${stamp}.indexer.started` ) seconds"

touch ${stamp}.end
echo "script done in $( expr `stat -c %X  ${stamp}.end` - `stat -c %X  ${stamp}.start` ) seconds"


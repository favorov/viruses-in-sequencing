#!/bin/bash
#$ -S /bin/bash
#$ -q zappa
#$ -cwd
#$ -pe zappa-pe 8

timestamp=${outputdir}/timestamp.align.against.hpv16.txt

echo "Aligning $wgs1 and $wgs2 against $reference and output bam to ${outwgs}"
if [ ! -f $timestamp ]
then
	module load bwa
	module load samtools
	echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hpv16.sh $wgs1 $iter $outputdir $reference $sample"
pe=4

	wgs2=${wgs1/_1.fq/_2.fq}
	outwgs="${outputdir}${iter}_${sample}.bam"
	echo "bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -"
	bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -
	touch $timestamp	
	echo 'done..'
else
	echo "The timestamp $timestamp was set before"
fi
	

#samtools index $outwgs
#outwgsHPV=${outwgs/'.bam'/'.HPV.sam'}
#samtools view -H $outwgs > $outwgsHPV
#samtools view $outwgs | grep "NC_001526" >> $outwgsHPV
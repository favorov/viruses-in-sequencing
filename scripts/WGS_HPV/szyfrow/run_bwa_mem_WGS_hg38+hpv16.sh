#!/bin/bash
#$ -S /bin/sh
#$ -q zappa
#$ -cwd
#$ -pe zappa-pe 8
module load bwa
module load samtools

pe=4

outwgs="${outputdir}/${sample}_${iter}.bam"

timestamp=${outputdir}/align.${sample}_${iter}.against.hg38+hpv16.txt

wgs2=${wgs1/_1.fq/_2.fq}

echo "Aligning $wgs1 and $wgs2 against $reference (pair $iter) and output bam, pair ${iter}, output to ${outwgs}"
if [ ! -f $timestamp ]
then
	echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hg38+hpv16.sh $wgs1 $iter $outputdir $reference $sample"
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

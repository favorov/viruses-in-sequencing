#!/bin/bash
#$ -S /bin/sh
#$ -q zappa
#$ -cwd
##$ -pe zappa-pe 8
module load bwa
module load samtools

pe=1

outwgs="${outputdir}/${sample}_${iter}"

stamp=${outputdir}/align.${sample}_${iter}.against.hg38+hpv16

wgs2=${wgs1/_1.fq/_2.fq}

echo "Aligning $wgs1 and $wgs2 against $reference (pair $iter) and output bam, output to ${outwgs}.bam"
if [ ! -f ${stamp}.done ]
then
	touch ${stamp}.start
	echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hg38+hpv16.sh $wgs1 $iter $outputdir $reference $sample"
	echo "bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools view -bh - > $outwgs.unsorted.bam"
	bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools view -bh - > $outwgs.unsorted.bam 
	echo "samtools sort -@$pe -o $outwgs.bam $outwgs.unsorted.bam"
	samtools sort -f -@$pe $outwgs.unsorted.bam $outwgs.bam
	#@ means treads in sort (default 1) and additional threads in input (default 0)
	echo "samtools index -@$(expr pe - 1) $outwgs.bam"
	samtools index -@$(expr pe - 1) $outwgs.bam
	touch ${stamp}.done
	seconds=$(expr `stat -c %X  ${stamp}.done` - `stat -c %X  ${stamp}.start`)
	echo "done in ${seconds} seconds"
else
	echo "The stamp ${stamp}.done was set before"
fi

#outwgsHPV=${outwgs/'.bam'/'.HPV.sam'}
#samtools view -H $outwgs > $outwgsHPV
#samtools view $outwgs | grep "NC_001526" >> $outwgsHPV

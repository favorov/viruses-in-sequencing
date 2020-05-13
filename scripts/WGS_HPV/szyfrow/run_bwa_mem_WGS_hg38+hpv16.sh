#!/bin/bash
#$ -S /bin/sh
#$ -q zappa
#$ -cwd
#$ -pe zappa-pe 8
module load bwa
module load samtools

pe=4

outwgs="${outputdir}/${sample}_${iter}.bam"

stamp=${outputdir}/align.${sample}_${iter}.against.hg38+hpv16

wgs2=${wgs1/_1.fq/_2.fq}

echo "Aligning $wgs1 and $wgs2 against $reference (pair $iter) and output bam, pair ${iter}, output to ${outwgs}"
if [ ! -f ${stamp}.done ]
then
	touch ${stamp}.start
	echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hg38+hpv16.sh $wgs1 $iter $outputdir $reference $sample"
	echo "bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -"
	bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -
	touch ${stamp}.done
	let seconds = `stat -c %X  ${stamp}.done` - `stat -c %X  ${stamp}.start`
	echo "done in ${seconds} seconds"
else
	echo "The stamp ${stamp}.done was set before"
fi

#samtools index $outwgs
#outwgsHPV=${outwgs/'.bam'/'.HPV.sam'}
#samtools view -H $outwgs > $outwgsHPV
#samtools view $outwgs | grep "NC_001526" >> $outwgsHPV

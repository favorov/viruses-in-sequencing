#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 8

echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_hg38+hpv16.sh $wgs1 $iter $outputdir $reference $sample"
pe=4

wgs2=${wgs1/_1.fq/_2.fq}
outwgs="${outputdir}${iter}_${sample}.bam"
echo "bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -"
bwa mem -t $pe -T 20 $reference $wgs1 $wgs2 | samtools sort -@$pe -o $outwgs -
samtools index $outwgs
#outwgsHPV=${outwgs/'.bam'/'.HPV.sam'}
#samtools view -H $outwgs > $outwgsHPV
#samtools view $outwgs | grep "NC_001526" >> $outwgsHPV

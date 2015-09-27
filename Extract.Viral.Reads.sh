samtools view -Sbh alignments.sam > alignments.bam
#samtools view -bh alignments.bam > alignments.bam
samtools index alignments.bam 
samtools sort alignments.bam  alignments.sorted
samtools index alignments.sorted.bam 
samtools view -bh -o hpv.bam alignments.sorted.bam hpv16 hpv33 hpv35

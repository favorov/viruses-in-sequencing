#!/bin/bash
samtools fastq -f 4 TCGA-CV-6003-11A-01D-1681_120427_SN1120_0137_BD0T3FACXX_s_8_rg.sorted.bam > filtered.fastq
bwa mem -k 15 hMPV.fasta filtered.fasta | samtools view -F 4 -hS > aln-filt-15.sam

#$ -q zappa 
#$ -S /bin/bash
#$ -cwd
#$ -j y
##$ -l mem_free=6G,h_vmem=12G

#!/bin/bash
magicblast=/home/favorov/usr/local/bin/magicblast
$magicblast -query reads_of_insert.fastq -db ~/data/blast-db-hg19/hg19.fa -infmt fastq > reads-again-hg19.sam

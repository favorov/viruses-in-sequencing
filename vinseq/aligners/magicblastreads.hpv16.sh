#$ -q zappa 
#$ -S /bin/bash
#$ -cwd
#$ -j y
##$ -l mem_free=6G,h_vmem=12G

#!/bin/bash
magicblast=/home/favorov/usr/local/bin/magicblast
$magicblast -query reads_of_insert.fastq -subject hpv16.fa -infmt fastq > reads-mb-against-hpv16.sam

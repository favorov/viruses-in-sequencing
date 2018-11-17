#$ -q zappa 
#$ -S /bin/bash
#$ -cwd
#$ -j y
##$ -l mem_free=6G,h_vmem=12G

#!/bin/bash

. /etc/profile.d/modules.sh

module load sharedapps
module load bwa

bwa mem hpv16.fa reads_of_insert.fastq > reads-bwa-against-hpv16.sam

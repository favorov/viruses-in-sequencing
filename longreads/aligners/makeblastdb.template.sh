#$ -q zappa 
#$ -S /bin/bash
#$ -cwd
#$ -j y
##$ -l mem_free=6G,h_vmem=12G

#!/bin/bash
makeblastdb -in hg19.fa -parse_seqids -dbtype nucl

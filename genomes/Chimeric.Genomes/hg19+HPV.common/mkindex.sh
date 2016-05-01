#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load bowtie/1.1.1
bowtie-build chr1.fa,chr2.fa,chr3.fa,chr4.fa,chr5.fa,chr6.fa,chr7.fa,chr8.fa,chr9.fa,chr10.fa,chr11.fa,chr12.fa,chr13.fa,chr14.fa,chr15.fa,chr16.fa,chr17.fa,chr18.fa,chr19.fa,chr20.fa,chr21.fa,chr22.fa,chrX.fa,chrY.fa,hpv16.fa,hpv18.fa,hpv31.fa,hpv33.fa,hpv35.fa,hpv39.fa,hpv49.fa,hpv51.fa,hpv52.fa,hpv56.fa,hpv58.fa,hpv59.fa,hpv66.fa,hpv68.fa hg19+hpv

#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh
module load sharedapps
module load bowtie/1.1.1
bowtie-build hpv16.fa,hpv33.fa,hpv35.fa hpv

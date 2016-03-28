#!/bin/bash
#we run it from the folder (fastq in this project) with all the JHUJC subfoders with cfasta are in 
name=18732
t=JHUJC01001_027_18732_Enrich/raw/viral-reads.sam
c=JHUJC01001_028_18732_Total/raw/viral-reads.sam
cat << ENDSCRIPT | qsub -N macs.$name -cwd -S /bin/bash -j y
	/etc/profile.d/modules.sh
	module load sharedapps
	module load samtools
	macs2 callpeak -t $t -c $c -n $name --nomodel -g 25000 
	ENDSCRIPT

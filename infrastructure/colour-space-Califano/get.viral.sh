#!/bin/bash
#we run it from the folder where fastq falder with all the JHUJC subfoders with cfata are are
for dir in fastq/JHUJC*
do
	echo $dir 
	pushd $dir/raw
	qsub -v folder=. -N extract.viral.from.colour.$dir ~/viruses-in-sequencing/scripts/extract.hpv.from.cfasta.sh
	popd
done

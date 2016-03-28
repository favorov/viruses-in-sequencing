#!/bin/bash
#we run it from the folder (fastq in this project) with all the JHUJC subfoders with cfasta are in 
for dir in JHUJC*
do
	echo $dir 
	pushd $dir/raw
	qsub -v folder=. -N extract.viral.from.colour.$dir ~/viruses-in-sequencing/scripts/extract.hpv.from.cfasta.sh
	popd
done

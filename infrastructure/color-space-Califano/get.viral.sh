#!/bin/bash
#we run it from the fasta folder where all the JHUJC subfoders are
for dir in JHUJC*
do
	echo $dir 
	pushd $dir/raw
	qsub -v folder=. -N extract.viral.from.colour.$dir ~/viruses-in-sequencing/scripts/extract.hpv.from.cfasta.sh
	popd
done

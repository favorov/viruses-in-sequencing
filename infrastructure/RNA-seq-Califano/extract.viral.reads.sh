#!/bin/bash
#we run it from the folder where all the DGay subfoders are
for dir in DGay*
do
	echo $dir 
	pushd $dir
	qsub -v folder=. -N extract.$dir ~/viruses-in-sequencing/scripts/Extract.Viral.Reads.sh
	popd
done

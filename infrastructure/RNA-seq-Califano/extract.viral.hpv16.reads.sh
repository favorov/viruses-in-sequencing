#!/bin/bash
#we run it from the folder where all the DGay subfoders are
for dir in DGay*
do
	echo $dir 
	pushd $dir
	qsub -v folder=. -N extract.hpv16.$dir ~/viruses-in-RNA-seq/scripts/Extract.Viral.hpv16.Reads.sh
	popd
done

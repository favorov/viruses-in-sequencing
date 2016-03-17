#!/bin/bash
#we run it from the folder where all the DGay subfoders are
for dir in DGay*
do
	echo $dir 
	pushd $dir
	qsub -v folder=. -N get.unmapped.$dir ~/viruses-in-RNA-seq/Get.Unmapped.Reads.Sample.sh
	popd
done

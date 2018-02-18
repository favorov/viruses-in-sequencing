#!/bin/bash
#we run it from the folder where all the DGay subfoders are
for dir in DGay*
do
	dir=${dir}/virus-findings
	echo $dir 
	pushd $dir
	command="~/viruses-in-sequencing/go-scripts/hpv16samfilter"
	echo "#$ -S /bin/bash" > command.sh
	chmod 755 command.sh
	echo $command >> command.sh
	qsub -N go.extract.hpv16.$dir -j y -cwd command.sh
	#cat "go run ~/viruses-in-sequencing/go-scripts/hpv16samfilter" | qsub -v folder=. -N go.extract.hpv16.$dir 
	#rm command.sh
	popd
done

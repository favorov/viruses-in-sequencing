#!/bin/bash
#we run it from the folder where all the DGay subfoders will resude 
for dir in /home/elana/CalifanoHPVOP/DGay*
do
	name=${dir##*/}
	echo $dir $name
	mkdir $name
	pushd $name
	ln -s $dir/alignments.sam .
	popd
done

#!/bin/bash
for dir in /home/elana/CalifanoHPVOP/DGay*
do
	name=${dir##*/}
	echo $dir $name
	mkdir $name
	pushd $name
	ln -s $dir/alignments.sam .
	popd
done

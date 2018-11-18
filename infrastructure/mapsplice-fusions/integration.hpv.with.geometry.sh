#!/bin/bash
for type in candidates raw
do
	echo $type :
	for sample in DGay* 
	do
		for virus in hpv16 hpv33 hpv35
		do
			fusions_file=$sample/virus-findings/fusions_${type}.txt
			if grep --quiet $virus ${fusions_file}
			then
				echo -e ${sample}'\t'$type'\t'${virus}
				grep ${virus} ${fusions_file} | cut -f1,2,3
			fi
		done
	done
done


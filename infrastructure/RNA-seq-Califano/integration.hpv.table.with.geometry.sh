#!/bin/bash
for type in candidates raw
do
	#echo $type :
	for sample in DGay* 
	do
		for virus in hpv16 hpv33 hpv35
		do
			fusions_file=$sample/virus-findings/fusions_${type}.txt
			if grep --quiet $virus ${fusions_file}
			then
				prefix="${sample} $type"
				grep ${virus} ${fusions_file} | cut -f1,2,3 | \
					awk -v pre="$prefix" '
						{
							gsub(/\t/, "  ");
							split($1,a,"~"); 
						}
						a[1]~/hpv/ {print pre,$1,a[1],$2,a[2],$3}
						a[2]~/hpv/ {print pre,$1,a[2],$3,a[1],$2}
					' 
			fi
		done
		exit 
		# devel
	done
done


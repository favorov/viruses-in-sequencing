#!/bin/bash
#$ -cwd

#echo current folder
echo "current folder is $PWD"


WGSdir="/mnt/mapr/group/ms-solid/DashaHNSCC/"
reference="/home/atgc/METHYLATION/HPV_cancer/RefGenomes/chimericHG38.fa"
outputdir="/mnt/mapr/group/ms-solid/DashaHNSCC/8521512003336/test_bwa_mem_JHU/bwa_mem_res/"
list=('8521512003243' '8521512003248' '8521512003263' '8521512003271' '8521512003274' '8521512003277' '8521512003280' '8521512003281' '8521512003282' '8521512003284' '8521512003288' '8521512003289' '8521512003292' '8521512003293' '8521512003298' '8521512003300' '8521512003301' '8521512003311' '8521512003313' '8521512003318' '8521512003323' '8521512003328' '8521512003330' '8521512003333' '8521512003336' '8521512003337' '8521512003338' '8521512003339' '8521512003340' '8521512003341')


for sample in ${list[@]}
	do
	#find all fq.gz file pairs for sample
	wgsfiles=()
	#next string works only in 4.3+ bash versions
	#mapfile -d $'\0' -t wgsfiles < <(find . -name *$sample*_1.fq.gz -print0)
	#but the while loop works anyway
	while IFS=  read -r -d $'\0'; do
		wgsfiles+=("$REPLY")
	done < <(find $WGSdir -name *$sample*_1.fq.gz -print0)
	iter=1
	#run bwa mem for each pair in sample
	for wgs1 in "${wgsfiles[@]}"
		do
		echo "qsub  -o $outputdir -e $outputdir run_bwa_mem_WGS_JHU.sh $wgs1 $iter $outputdir $reference $sample"
		qsub  -o $outputdir -e $outputdir -v wgs1=$wgs1,iter=$iter,outputdir=$outputdir,reference=$reference,sample=$sample run_bwa_mem_WGS_JHU.sh
		((iter++))
		done
	done

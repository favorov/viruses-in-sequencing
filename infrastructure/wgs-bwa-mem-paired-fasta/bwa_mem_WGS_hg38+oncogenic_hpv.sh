#This is a spript that invokes run_bwa_mem_WGS_hg38+hpv16.sh that align by BWA mem against the hg38+hpv16 + convert to BAM + sort + index one pair of wgs fastq files
#run_bwa_mem_WGS_hg38 is invoked for each pair of fastq (a sample) in module lunux + SGE evironment by calling qsub
#(c) 2020 Mera Mukhina, Alexander Favorov
#!/bin/bash

#echo current folder
echo "current folder is $PWD"

tag="oncogenic_hpv"

WGSdir="/home/favorov/Califano/WGS/F15FTSUSAT0806_HUMbxtR/"
reference="/home/favorov/reference/chimeric_hg38+oncogenic-hpv/bwa_index/chimericHG38.fa"
outputdir="/home/favorov/Dasha/JHU-WGS-HPV/hg38+hpv-oncogenic/bams/"
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
		echo "qsub run_bwa_mem_WGS_paired_fasta.sh $wgs1 $iter $outputdir $reference $sample"
		#qsub  -o $outputdir -e $outputdir -v wgs1=$wgs1,iter=$iter,outputdir=$outputdir,reference=$reference,sample=$sample run_bwa_mem_WGS_hg38+hpv16.sh	
		qsub  -v wgs1=$wgs1,iter=$iter,outputdir=$outputdir,reference=$reference,sample=$sample,tag=$tag run_bwa_mem_WGS_paired_fasta.sh
		((iter++))
		done
	done

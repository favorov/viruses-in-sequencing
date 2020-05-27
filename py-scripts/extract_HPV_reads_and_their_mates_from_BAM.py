#$ -S /usr/bin/env python3
#$ -cwd
#$ -pe smp 8

import os
import sys
import glob
import time
import pysam #samtools analog

#from extract_HPV_reads_and_their_mates_from_BAM_module import * #storage for all specific functions we need

'''
This script allows to analyse sorted WGS bwa mem results on JHU server

Input:
dir with sorted and indexed BAM files with alignments against HG38+HPV
Output:
files with viral reads and their pairs sample.HPV.sam and sample.HPV_with_mates.sam
'''


def grepViralReads(infile, seq):
	'''
	in:SAM file (and viral sequence name for grep)
	out:SAM with header with viral reads, SAM with header with viral reads and their pairs
	'''
	print('collecting HPV reads...')
	#copy header and grep all viral reads from sam file
	outfile=infile.replace('bam','HPV.sam')
	os.system("samtools view -H %s > %s" % (infile,outfile))
	os.system("samtools view %s | fgrep %s - >> %s" % (infile,seq,outfile))
	print('viral reads collected from SAM file')

def grepMates(infile,outfile):
	'''
	in: full SAM file AND file with grep'ed viral reads
	out: SAM file with viral reads and their mates
	'''
	print('collecting mates...')
	#1) collect read names
	HPVreads=[]
	with pysam.AlignmentFile(outfile,'r') as sam:
		for read in sam:
				HPVreads.append(str(read.query_name))
	HPVreads_set=set(HPVreads)
	with open('temp_hpv_reads_id.txt',mode='w') as HPVset:
		[HPVset.write(read+"\n") for read in HPVreads_set]
	print(str(len(HPVreads_set))+" HPV reads are somehow mapped on HPV")
	
	#2) grep HPVreads and their mated from bam file
	HPVmates=infile.replace('.bam','.HPV_with_mates.sam')
	#https://www.biostars.org/p/68358/ claims that grep like 'LC_ALL=C grep -w -F -f temp_hpv_reads_id.txt < infile > outfile could be faster but
	#a) I have no idea how LC_ALL=C could help
	#b) it's actually slower than the variant below
	os.system("samtools view %s | fgrep -f temp_hpv_reads_id.txt - > %s" % (infile,HPVmates))
	print('all viral reads and their mates are collected from SAM file')
	os.remove('temp_hpv_reads_id.txt')


def main():
	WGSdir="/mnt/mapr/group/ms-solid/DashaHNSCC/"
	reference="/home/atgc/METHYLATION/HPV_cancer/RefGenomes/chimericHG38.fa"
	outputdir="/mnt/mapr/group/ms-solid/DashaHNSCC/8521512003336/test_bwa_mem_JHU/bwa_mem_res/"
	samples=['8521512003243','8521512003248','8521512003263','8521512003271','8521512003274','8521512003277','8521512003280','8521512003281','8521512003282','8521512003284','8521512003288','8521512003289','8521512003292','8521512003293','8521512003298','8521512003300','8521512003301','8521512003311','8521512003313','8521512003318','8521512003323','8521512003328','8521512003330','8521512003333','8521512003336','8521512003337','8521512003338','8521512003339','8521512003340','8521512003341']
	pe=8
	for sample in samples:
		list=glob.glob(outputdir+"*"+sample+'.bam')
		if not list:
			print("No BAM files for "+sample+" sample")
		else:
			print("sample %s: %s files" % (sample,len(list)))
			#next string works in python3+ only
			#print(*list, sep='\n')
			for file in list:
				print("Current file is "+file)
				outfile=file.replace('bam','HPV.sam')
				tmst=file.replace('bam','timestamp')
				#check if we already have the results and run scripts for missing files
				if not os.path.exists(tmst):
					start_time = time.time()
					grepViralReads(file,'NC_001526')
					with open(tmst,mode='w') as first:
						first.write("grep HPV reads finished in %s seconds" % (time.time() - start_time))
				else:
					print('HPV reads already present')
						
				if "grep mates finished" not in open(tmst).read():
					start_time = time.time()
					grepMates(file,outfile)
					with open(tmst,mode='a+') as second:
						second.write("grep mates finished in %s seconds" % (time.time() - start_time))
				else:
					print('mates already present')
				
			
#here, we finally run it all :)
if __name__ == "__main__":
    main()
		


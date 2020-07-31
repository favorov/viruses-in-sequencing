#$ -S python3
#$ -cwd
##$ -pe zappa-pe 8
#$ 
#extracts everything to .
# tha bam folder is ./bams that we make with a link befor starting the script - it is the easiest flexibility
#the output folder is the current
#timestamps live is ./stamps

#module load samtools/1.6.0

import os
import sys
import glob
import re
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

def grepViralReads(infile, virlist, hpvoutfile, tmstamp):
	'''
	in:SAM file (and viral sequence name for grep)
	out:SAM with header with viral reads, SAM with header with viral reads and their pairs
	'''
	start_time = time.time()
	virlist.insert(0,'') #add first "" to get the -e options list starting with -e
	eoptions=" -e ".join(virlist)
	print('collecting HPV reads...')
	#copy header and grep all viral reads from sam file
	os.system("samtools view -H %s > %s" % (infile,hpvoutfile))
	#os.system("samtools view -h %s | fgrep %s - > %s" % (infile,seq,hpvoutfile))
	os.system("samtools view %s | fgrep %s - >> %s && echo 'grep HPV reads finished' >> %s" % (infile,eoptions,hpvoutfile, tmstamp))
	if os.path.exists(tmstamp):
		with open(tmstamp,mode='a+') as first:
			first.write(" in %s seconds\n" % (time.time() - start_time))
			print('viral reads collected from SAM file')
	else:
		print('grepViralReads failed for file %s (((' % infile)


def grepMates(infile,nomateinfile,mateoutfile,tmstamp):
	'''
	in: full SAM file AND file with grep'ed viral reads
	out: SAM file with viral reads and their mates
	'''
	start_time = time.time()
	print('collecting mates...')
	#1) collect read names

	HPVreads=[]
	with pysam.AlignmentFile(nomateinfile,'r') as sam:
		for read in sam:
				HPVreads.append(str(read.query_name))
	HPVreads_set=set(HPVreads)
	with open('temp_hpv_reads_id.txt',mode='w') as HPVset:
		[HPVset.write(read+"\n") for read in HPVreads_set]
	print(str(len(HPVreads_set))+" HPV reads are somehow mapped on HPV")
	
	#2) grep HPVreads and their mated from bam file
	#https://www.biostars.org/p/68358/ claims that grep like 'LC_ALL=C grep -w -F -f temp_hpv_reads_id.txt < infile > outfile could be faster but
	#a) I have no idea how LC_ALL=C could help
	#b) it's actually slower than the variant below
	#os.system("samtools view %s | fgrep -f temp_hpv_reads_id.txt - > %s" % (infile,mateoutfile))
	os.system("samtools view -H %s > %s" % (infile,mateoutfile))
	os.system("samtools view %s | fgrep -f temp_hpv_reads_id.txt - >> %s && echo 'grep mates finished' >> %s" % (infile,mateoutfile,tmstamp))
	if "grep mates finished" in open(tmstamp).read():
		with open(tmstamp,mode='a+') as second:
			second.write(" in %s seconds" % (time.time() - start_time))
		print('all viral reads and their mates are collected from SAM file')
	else:
		print('grepMates failed for file %s' % infile)
	os.remove('temp_hpv_reads_id.txt')

#>NC_001526.4 Human papillomavirus type 16, complete genome
#>NC_001357.1 Human papillomavirus - 18, complete genome
#>KX514430.1 Human papillomavirus type 31 isolate 295, complete genome
#>M12732.1 Human papillomavirus type 33, complete genome
#>M74117.1 Human papillomavirus type 35 complete genome
#>KX514417.1 Human papillomavirus type 39 isolate 16B, complete genome
#>KC470260.1 Human papillomavirus type 45 isolate Qv34163, complete genome
#>NC_001591.1 Human papillomavirus type 49, complete genome
#>KT725857.1 Human papillomavirus type 51 isolate HPV51-155-24, complete genome
#>LC373207.1 Human papillomavirus type 52 TK094 DNA, complete genome
#>KX514418.1 Human papillomavirus type 56 isolate 60B, complete genome
#>KY225967.1 Human papillomavirus type 58 isolate ZWE051402, complete genome
#>KC470266.1 Human papillomavirus type 59 isolate Qv33361, complete genome
#>LC511686.1 Human papillomavirus type 66 TK130 DNA, complete genome
#>KX514431.1 Human papillomavirus type 68 isolate 295, complete genome


def main():
	#bamdir="/mnt/mapr/group/ms-solid/DashaHNSCC/8521512003336/test_bwa_mem_JHU/bwa_mem_res/"
	#bamdir="/home/favorov/Dasha/JHU-WGS-HPV/hg38+hpv16/chimeric-bams/"
	bamdir="bams/"
	samples=['8521512003243','8521512003248','8521512003263','8521512003271','8521512003274','8521512003277','8521512003280','8521512003281','8521512003282','8521512003284','8521512003288','8521512003289','8521512003292','8521512003293','8521512003298','8521512003300','8521512003301','8521512003311','8521512003313','8521512003318','8521512003323','8521512003328','8521512003330','8521512003333','8521512003336','8521512003337','8521512003338','8521512003339','8521512003340','8521512003341']
	#virlist=['NC_001526']
	virlist=['NC_001526', 'NC_001357', 'KX514430', 'M12732', 'M74117', 'KX514417', 'KC470260', 'NC_001591', 'KT725857', 'LC373207', 'KX514418', 'KY225967', 'KC470266', 'LC511686', 'KX514431']
	outdir="./"
	stampdir=outdir+"stamps/"
	for sample in samples:
		list=glob.glob(bamdir+sample+'_[0-9].bam')
		if not list:
			print("No BAM files for "+sample+" sample")
		else:
			print("sample %s: %s files" % (sample,len(list)))
			#next string works in python3+ only
			#print(*list, sep='\n')
			for bamfile in list:
				print("Current file is "+bamfile)
				bamfilename=os.path.basename(bamfile)
				HPVoutfile=outdir+re.sub('bam$', 'HPV.sam', bamfilename)
				HPVwithmatesoutfile=outdir+re.sub('bam$', 'HPV_with_mates.sam', bamfilename)
				tmst=stampdir+re.sub('bam$', 'timestamp', bamfilename)
				#check if we already have the results and run scripts for missing files
				if not os.path.exists(tmst):
					grepViralReads(bamfile,virlist,HPVoutfile,tmst)
				else:
					print('HPV reads already present')
						
				if os.path.exists(tmst) and "grep mates finished" not in open(tmst).read():
					grepMates(bamfile,HPVoutfile,HPVwithmatesoutfile,tmst)
				else:
					print('mates already present')
				
			
#here, we finally run it all :)
if __name__ == "__main__":
    main()
		


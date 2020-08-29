#$ -S python3
#$ -cwd
##$ -pe zappa-pe 8
#$ 
#extracts everything to .
# tha bam folder is ./bams that we make with a link befor starting the script - it is the easiest flexibility

import os
import sys
import glob
import re
import time


'''
This script allows to calculate coverage per chromosome for sorted WGS bwa mem results on JHU server.
Input:
dir with sorted and indexed BAM files with alignments against HG38+HPV
Output:
files with mean coverages for hg38 for each bam file + tmstmps
!!! script requires samtools 1.10+ version
'''


def calculateCoverage(listfile, outfile, tmstamp):
	'''
	in: file with list of BAM's for each sample, outfile and timestamp filename
	out: tabs with coverage,timestamp files
	'''
	start_time = time.time()
	print('calculating coverage...')
	#samtools coverage option works only for samtools 1.10+ version
	os.system("samtools coverage -b %s > %s" % (listfile,outfile))
	with open(tmstamp,mode='a+') as first:
		first.write("coverage calculated in %s seconds\n" % (time.time() - start_time))
		print("coverage calculated for %s" % listfile)


def main():
	#bamdir="/home/mukhinav/cohort_data/HPV-WGS-extract/"  - these data were used for testing on LaScala
	bamdir="bams/"
	samples=['8521512003243','8521512003248','8521512003263','8521512003271','8521512003274','8521512003277','8521512003280','8521512003281','8521512003282','8521512003284','8521512003288','8521512003289','8521512003292','8521512003293','8521512003298','8521512003300','8521512003301','8521512003311','8521512003313','8521512003318','8521512003323','8521512003328','8521512003330','8521512003333','8521512003336','8521512003337','8521512003338','8521512003339','8521512003340','8521512003341']
	for sample in samples:
		list=glob.glob(bamdir+sample+'_[0-9].bam')
		#list=glob.glob(bamdir+sample+'_[0-9].HPV_with_mates.sam.bam') - these data were used for testing on LaScala
		if not list:
			print("No BAM files for "+sample+" sample")
		else:
			print("sample %s: %s files" % (sample,len(list)))
			#create temporary file storing list of bam file for each sample
			outfile=sample+'.coverage.tab'
			listfile=sample+'list.txt'
			with open(listfile, 'w') as f:
				[f.write("%s\n" % bamfile) for bamfile in list]
			tmst=sample+'_coverage.tmst'
			#check if we already have the results and run scripts for missing files
			if not os.path.exists(tmst):
				calculateCoverage(listfile,outfile,tmst)
				os.remove(listfile)
			else:
				print('coverage already calculated')

			
#here, we finally run it all :)
if __name__ == "__main__":
    main()

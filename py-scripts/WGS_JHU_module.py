#$ -S /usr/bin/env python3
#$ -cwd
#$ -pe smp 8

import os
import glob
import pysam

pe=8

def createBigWig(infile):
	'''
	in - sample ID (number)
	out - coverage file sample.bigwig
	'''
	print('checking if bai file exists...')
	if not os.path.exists(infile+'.bai'):
		os.system('samtools index '+infile)
	print('starting BigWig...')
	bwout=infile.replace('bam','bw')
	os.system("bamCoverage -p %s -b %s -o %s" % (pe,infile, bwout))
	print('BigWig created')

def countDepth(sample, position):
	'''
	in - sample, position
	out - depth for given position
	'''
	pass

def collectReads(sample, from_chr, to_chr):
	'''
	returns list of reads mapping on given region
	'''
	pass


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

#!/usr/bin/env python3
import pysam

file=input('Please provide SAM/BAM file :')
try:
	with pysam.AlignmentFile(file,'r') as sam:
			for read in sam:
				print(read)
				break
except IOError:
	print('No such file: '+file)
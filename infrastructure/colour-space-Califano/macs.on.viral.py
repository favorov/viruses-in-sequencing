#!python3
#requires python3
#we run it from the folder (fastq in this project) with all the JHUJC subfoders with cfasta are in
import os
import glob

def print_command(enrfolder,totfolder,name):
	print('''
cat << ENDSCRIPT | qsub -N macs.%s -cwd -S /bin/bash -j y
#!/bin/bash
. /etc/profile.d/modules.sh
module load sharedapps
module load macs 
macs2 callpeak -t %s/raw/viral-reads.sam -c %s/raw/viral-reads.sam -n %s --nomodel -g 25000 
ENDSCRIPT''' % (name,enrfolder,totfolder,name))


def main():
	foldernames=glob.glob('JHUJC0*') # just dir
	#now, we will gather sample names, the names are JHUJC0***_@@@_SAMPLE_@@@@
	samplenames=[]
	for foldername in foldernames:
		samplenames.append(foldername.split('_')[2])
	samplenames=set(samplenames) #we do it unique 
	for samplename in samplenames: #now we start the samples on-by-one
		enrfolder=''
		totfolder=''
		for foldername in foldernames:
			if samplename in foldername:
				if 'nrich' in foldername:
					enrfolder=foldername #this is the 'total' foldername
				if 'otal' in foldername:
					totfolder=foldername #this is the 'enrich' foldername
		print_command(enrfolder,totfolder,samplename)

#here, we finally run it all :)
if __name__ == "__main__":
	main()


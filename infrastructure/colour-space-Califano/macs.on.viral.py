#!python3
#requires python3
#we run it from the folder (fastq in this project) with all the JHUJC subfoders with cfasta are in
import os
import glob

def print_command(t,c,name):
	print('''
cat << ENDSCRIPT | qsub -N macs.%s -cwd -S /bin/bash -j y
#!/bin/bash
. /etc/profile.d/modules.sh
module load sharedapps
module load macs 
macs2 callpeak -t %s -c %s -n %s --nomodel -g 25000 
ENDSCRIPT''' % (name,t,c,name))


def main():
    foldernames=glob.glob('JHUJC0*')
		print foldernames
    #name='18732'
    #t='JHUJC01001_027_18732_Enrich/raw/viral-reads.sam'
    #c='JHUJC01001_028_18732_Total/raw/viral-reads.sam'
    #print_command(t,c,name)



#here, we finally run it all :)
if __name__ == "__main__":
    main()


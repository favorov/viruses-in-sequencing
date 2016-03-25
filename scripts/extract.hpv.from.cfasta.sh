#!/bin/bash
touch virus-detection-started.txt

cfasta=`ls -m *csfasta | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g'`
qual=`ls -m *QV.qual | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g'`
#ln -m output all via comma
#sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g
#is magic sytaxis or replacing \n's 
#http://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed

ref=~/viruses-in-sequencing/genomes/Viral.Genomes/HPV/hpv

bowtie -S -C -f -Q $qual $ref $cfasta | samtools view -Sh -F4 - > viral-reads.sam 
#bowtie -S -C -f  -Q Daria_set2_2013_09_17_1_04_27281_Enrich_F3.QV.qual,Daria_set2_2013_09_17_1_05_27281_Enrich_F3.QV.qual,Daria_set2_2013_09_17_1_06_27281_Enrich_F3.QV.qual ~/viruses-in-sequencing/genomes/Viral.Genomes/HPV/hpv Daria_set2_2013_09_17_1_04_27281_Enrich_F3.csfasta,Daria_set2_2013_09_17_1_05_27281_Enrich_F3.csfasta,Daria_set2_2013_09_17_1_06_27281_Enrich_F3.csfasta | samtools view -Sh -F4 - > viral-reads.sam 
touch virus-detection-completed.txt

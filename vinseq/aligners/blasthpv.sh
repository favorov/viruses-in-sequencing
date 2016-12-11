magicblast -query reads_of_insert.fastq -subject hpv16.fasta -infmt fastq > blast.against.hpv16.sam
magicblast -query reads_of_insert.fastq -subject hpv-human.fasta -infmt fastq > blast.against.hpv-human.sam
magicblast -query reads_of_insert.fastq -subject hpv-common.fasta -infmt fastq > blast.against.hpv-all.sam
magicblast -query reads_of_insert.fastq -subject hpv-common.fasta -infmt fastq > blast.against.hpv-common.sam

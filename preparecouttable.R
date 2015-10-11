library("Rsamtools")
library("GenomicAlignments")
library("GenomicFeatures")
library(DESeq2)
library(org.Hs.eg.db)
library(gplots)

second<-function(li){li[[2]]}

bamlist<-list.files(full.names = T,pattern = 'viral_reads.bam',recursive=TRUE)
bamfiles <- BamFileList(bamlist, yieldSize=2000000)
names(bamfiles)<-sapply(strsplit(bamlist,'/'),second)
gtffile <- file.path('~/viruses-in-RNA-seq/Viral.Genes.Annotation/hpv.gtf') 
txdb <- makeTxDbFromGFF(gtffile, format="gtf")
genes <- exonsBy(txdb, by="gene")
se <- summarizeOverlaps(features=genes, reads=bamfiles, mode="Union", singleEnd=T, ignore.strand=TRUE, fragments=F )
assay(se)
save(file='hpv_expression.Rda',list=c('se'))

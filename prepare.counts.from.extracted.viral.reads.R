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
counts<-matrix(nrow=0,ncol=length(bamlist))
for (i in 1:length(genes))
{
	se<-summarizeOverlaps(features=genes[i], reads=bamfiles, mode="Union", singleEnd=T, ignore.strand=TRUE, fragments=F )
	counts<-rbind(counts,assay(se))
}
save(file='hpv_expression.Rda',list=c('counts'))

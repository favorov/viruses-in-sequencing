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
#gtf does not have the whole virus info, is it good not
list.of.full.counters<-sapply(bamfiles,function(bam){
	table(as.character(scanBam(bam)[[1]]$rname))
})

hpv16<-sapply(list.of.full.couters,function(vec) ifelse(is.na(vec['hpv16']),0,vec['hpv16']))
hpv33<-sapply(list.of.full.couters,function(vec) ifelse(is.na(vec['hpv33']),0,vec['hpv33']))
hpv35<-sapply(list.of.full.couters,function(vec) ifelse(is.na(vec['hpv35']),0,vec['hpv35']))
hhv4<-sapply(list.of.full.couters,function(vec) ifelse(is.na(vec['hhv4']),0,vec['hhv4']))
hhv4t1<-sapply(list.of.full.couters,function(vec) ifelse(is.na(vec['hhv4t1']),0,vec['hhv4t1']))

counts<-rbind(counts,hpv1,hpv33,hpv35,hhv4,hhv4t1)

#save(file='hpv_expression.Rda',list=c('counts'))

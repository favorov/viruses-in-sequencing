library("Rsamtools")
library("GenomicAlignments")
library("GenomicFeatures")
library(DESeq2)
library(org.Hs.eg.db)
library(gplots)

bamfiles <- BamFileList(list.files(full.names = T,pattern = 'viral_reads.bam'), yieldSize=2000000)

gtffile <- file.path('~/viruses-in-sequencing/Viral.Genes.Annotation/hpv.gtf') 
txdb <- makeTranscriptDbFromGFF(gtffile, format="gtf")
genes <- exonsBy(txdb, by="gene")

se <- summarizeOverlaps(features=genes, reads=bamfiles, mode="Union", singleEnd=T, ignore.strand=TRUE, fragments=F )

head(assay(se))



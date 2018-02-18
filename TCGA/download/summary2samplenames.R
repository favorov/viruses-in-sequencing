#summary.tsv is downloaded from CGHUB
write.table(file='samplenames.txt',substr(read.csv('summary.tsv',header=TRUE,sep='\t',stringsAsFactors = FALSE)[,2],1,15),row.names = FALSE,col.names = FALSE,quote = FALSE)

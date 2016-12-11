library(Rsamtools)
reads.geom.hist<-function(fname,hist.title=fname){
#name of sam file, no extesion
	samname<-paste0(fname,'.sam')
	bamname<-paste0(fname,'.bam')
	if (
		file.exists(samname)
		&&
		!file.exists(bamname)
	) asBam(samname,fname,overwrite=TRUE)
	if (!file.exists(bamname)) stop(paste0("No bam file ",bamname))
	reads<-scanBam(bamname)
	pdf(paste0(fname,'.pdf'))
	hist(reads[[1]]$pos,main=paste0(hist.title,': starts'))
	hist(reads[[1]]$pos+reads[[1]]$qwidth,main=paste0(hist.title,': ends'))
	hist(reads[[1]]$qwidth,main=paste0(hist.title,': lenghts'))
	dev.off()
}



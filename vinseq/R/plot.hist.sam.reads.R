library(Rsamtools)

#filters return logical vetor of the 
#same lenth as sam
all.good.filter<-function(sam){
	rep(TRUE,length(sam[[1]]))
}

hpv16.filter<-function(sam){
	sam$rname=='hpv16'
}

reads.geom.hist<-function(fname,hist.title=fname,filter=all.good.filter){
#name of sam file, no extesion
  len<-nchar(fname)
  if(tolower(substr(fname,len-3,len)=='.sam'))
    fname=substr(fname,1,len-4)
  if(tolower(substr(fname,len-3,len)=='.bam'))
    fname=substr(fname,1,len-4)
  samname<-paste0(fname,'.sam')
	bamname<-paste0(fname,'.bam')
	if (
		file.exists(samname)
		&&
		!file.exists(bamname)
	) {
	  message(samname)
	  asBam(samname,fname,overwrite=TRUE)
	}
	if (!file.exists(bamname)) stop(paste0("No bam file ",bamname))
	reads<-scanBam(bamname)
	pdf(paste0(fname,'.pdf'))
	flt<-filter(reads[[1]])
	hist(reads[[1]]$pos[flt],main=paste0(hist.title,': starts'))
	hist(reads[[1]]$pos[flt]+reads[[1]]$qwidth[flt],
		main=paste0(hist.title,': ends'))
	hist(reads[[1]]$qwidth[flt],main=paste0(hist.title,': lenghts'))
	dev.off()
}



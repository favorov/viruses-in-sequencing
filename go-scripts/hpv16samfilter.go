package main

import (
	"strings"
	"flag"
	"io"
	"bufio"
	"log"
	"os"
	"github.com/biogo/hts/sam"
)


//three parameters: input (sam) file, output (sam) file and the aim sequence name prefix (hpv)
//reads reads from input sam, created out sam witht the same header, but it writes there 
//only those reads that are on the aim or their mataes are in the aim.
func filter_reads(in, out, aim string ) {
	
	r, err := os.Open(in)
	if err != nil {
		log.Fatalf("Can not open read file %q: %q", in,err)
	}
	defer r.Close()

	samr, err := sam.NewReader(r)
	if err != nil {
		log.Fatalf("could not read sam from %q: %q", in,err)
	}
	
	wf, err := os.Create(out)
	if err != nil {
		log.Fatalf("could not open write file %q: %q", out, err)
	}
	defer wf.Close()

	w := bufio.NewWriter(wf)
	defer w.Flush()

	samw, err:=sam.NewWriter(w,samr.Header(),sam.FlagDecimal)
	if err != nil {
		log.Fatalf("could not open sam writer for output file %q: %q", out, err)
	}

	for {
		rec, err := samr.Read()
		if err == io.EOF {
		//bye !
			return
		}
		if err != nil {
			log.Fatalf("error reading sam file %q: %q", in, err)
		}
		if (  
				( rec.Flags & sam.Unmapped == 0 && strings.HasPrefix(rec.Ref.Name(),aim) ) ||	( rec.Flags & sam.Paired == sam.Paired && rec.Flags & sam.MateUnmapped == 0 &&  strings.HasPrefix(rec.MateRef.Name(),aim) ) ) {samw.Write(rec)}  //mapped in aim or pared and mate is mapped in aim
	}
	return
}


var (
	idir    = flag.String("idir", ".", "the dir with alignments.sam")
	odir    = flag.String("odir", ".", "the dir with the result viral_reads.sam")
	help    = flag.Bool("help", false, "display help")
)


func main() {
	
	flag.Parse()
	if *help {
		flag.Usage()
		os.Exit(0)
	}
	filter_reads(*idir+"/alignments.sam", *odir+"/viral_reads.sam","hpv")	
}

find -path '*findings*' -name alignments.sam -exec echo {} \; -exec sh ~/viruses-in-sequencing/scripts/whathpvarehere.sh {} \; > checkhpv.log

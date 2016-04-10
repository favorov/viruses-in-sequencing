manif=data/manifest
rm -f ${manif}/querylog.txt
touch  ${manif}/querylog.txt
for ID in `cat samplenames.txt`
do
  ~/cghub/bin/cgquery "disease_abbr=CESC&library_strategy=RNA-seq&legacy_sample_id=${ID}*&state=live&refassem_short_name=unaligned" -o ${manif}/${ID}.xml >> ${manif}/querylog.txt
done

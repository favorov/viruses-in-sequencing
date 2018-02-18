manif=data/manifest
mkdir -p ${manif}
rm -f ${manif}/querylog.txt
touch  ${manif}/querylog.txt
for ID in `cat samplenames.txt`
do
  echo ${ID}
  ~/cghub/bin/cgquery "disease_abbr=CESC&library_strategy=RNA-Seq&legacy_sample_id=${ID}*&state=live&refassem_short_name=unaligned" -o ${manif}/${ID}.xml >> ${manif}/querylog.txt
done

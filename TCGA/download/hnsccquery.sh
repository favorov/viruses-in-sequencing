manif=data/manifest
rm -f ${manif}/querylog.txt
touch  ${manif}/querylog.txt
for ID in `cat samplenames.txt`
do
  ~/cghub/bin/cgquery "disease_abbr=HNSC&library_strategy=WGS&legacy_sample_id=${ID}*&sample_type=01" -o ${manif}/${ID}.xml >> ${manif}/querylog.txt
done

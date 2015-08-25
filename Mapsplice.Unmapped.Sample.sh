#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh

module load sharedapps
module load python2.7/2.7.6

folder=${1-'./DGay10-26144'}

pushd $folder

echo "started looking for HPV in folder $folder"

touch mapsplice.unmapped.start.timestamp.txt
virexbase=/home/favorov/virus-expression
mapsplice=$virexbase/Mapsplice/MapSplice-v2.2.0/mapsplice.py
mkdir virus-findings
python2 $mapsplice --fusion-non-canonical -o virus-findings/ -c $virexbase/hg19+HPV -x $virexbase/hg19+HPV/hg19+hpv -1 unmapped1.fq -2 unmapped2.fq touch mapsplice.unmapped.stop.timestamp.txt

echo 'done..' 
popd > /dev/null 


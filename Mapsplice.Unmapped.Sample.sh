#$ -q zbatch
#$ -S /bin/bash
#$ -cwd
#$ -j y

. /etc/profile.d/modules.sh

module load sharedapps
module load python2.7/2.7.6
module load bowtie/1.1.1

scripthome=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )
virexbase=$scripthome/Chimeric.Genomes
mapsplice=~/Mapsplice/MapSplice-v2.2.0/mapsplice.py

folder=${1}
[[ ! $folder = *\/ ]] && folder=${folder}/
#if folder is not given with / add it
#folder is the working folder

pushd $folder > /dev/null

echo "started looking for HPV and EBV in folder $folder"

touch mapsplice.unmapped.start.timestamp.txt

mkdir -p virus-findings
#if not exists, create, otherwise, do nothing, no error

python2 $mapsplice --fusion-non-canonical -o virus-findings/ -c $virexbase/hg19+HPV+EBV -x $virexbase/hg19+HPV/hg19+hpv+ebv -1 unmapped1.fq -2 unmapped2.fq touch mapsplice.unmapped.stop.timestamp.txt

echo 'done..' 
popd > /dev/null 


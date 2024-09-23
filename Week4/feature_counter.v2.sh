#!/bin/bash 

link="https://ftp.ensembl.org/pub/current_gff3/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.46.112.gff3.gz"
organism=$(basename $link .gff3.gz)
if [[ ! -f ${organism}.gff3 ]];
then
  echo "Downloading organism ${organism}..."
  wget $link
  gunzip -f ${organism}.gff3.gz
else
  echo "Organism already exists!"
fi

awk -F '\t' '!/^#/ { counts++ } END { print "Total features detected: " counts }' ${organism}.gff3
# count individual features using AWK 
# loops over by ignoring comment lines and increases counter if compartment is encountered
awk -F '\t' '!/^#/ { counts[$3]++ } END { for(_ in counts) print counts[_] "\t" _ }' ${organism}.gff3 | sort -nr | head -10 > ${organism}.counts.txt
echo "Process has completed. Your resuls are ready here: ${organism}.counts.txt!"

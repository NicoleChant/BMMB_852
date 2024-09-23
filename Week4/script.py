#!/bin/bash 

accession=${1:-1}

if [[ $accession -eq 1 ]]; then
    echo "No accession was provided. Exiting..."
    exit 0
fi

set -e
echo -e "Detected accession ${accession}.\nProcessing accession ${accession}."
destdir=ncbi_dataset/data/$(basename ${accession})/genomic.gff 
download() { if [[ ! -f ${destdir} ]]; then 
            u=tmp${RANDOM}${RANDOM}${RANDOM}${RANDOM}
            mkdir ${u}/ && cd ${u}/ && datasets download genome accession ${accession} --include gff3 2> /dev/null && unzip ncbi_dataset.zip > /dev/null && mv ${destdir} ../${accession}.gff && cd .. && rm -rf ${u} ; fi }
if [[ ! -f ${accession}.gff ]]; then
    echo -e "Red Alert! Red Alert!\nUnable to detect accession. Initializing download protocol ${RANDOM}\n" && download
fi 

if [[ -f ${accession}.gff ]]; then
    echo "GFF File has been succesfully downloaded for accession ${accession}."
else
    echo "Failure to download the GFF file for provided accession ${accession}."
    exit 1
fi 

echo "Food is in the oven. Please wait..."
awk -F '\t' '!/^#/ { counts++ } END { print "Total features detected: " counts }' ${accession}.gff 
awk -F '\t' '!/^#/ { counts[$3]++ } END { for(_ in counts) print counts[_] "\t" _ }' ${accession}.gff | sort -nr > $(basename ${accession}).counts.txt
echo "Process has completed. Your resuls are ready here: $(basename ${accession}).counts.txt!"

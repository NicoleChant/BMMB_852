#!/bin/bash 

# It accepts an assembly accession either from genbank or refseq in the format GC[AF]_XXXXXXXXX.X+
# For instance, you can run by doing:
# bash script.sh GCA_00010121.23 (this doesn't exist!)

accession=${1:-"1"}
if [[ $accession == "1" ]]; then
    echo "No accession was provided. Exiting..."
    exit 0
fi

set -e
echo -e "Detected accession ${accession}.\nProcessing accession ${accession}."
destdir=ncbi_dataset/data/${accession}/genomic.gff 

if ! command -v datasets; then
  echo -e "Datasets command was not found!\nExiting..."
  exit 1
fi
# Download function to download for NCBI
# What it does:
# - Generates a temporary directory and downloads the GFF Accession within that temp directory and unzips it.
# - It renames correctly the GFF accession and deletes the temporary directory 
# - If the GFF file already exists it is not downloaded it again.

download() { if [[ ! -f ${destdir} ]]; then 
            u=tmp${RANDOM}${RANDOM}
            mkdir ${u}/ 
            cd ${u}/
            datasets download genome accession ${accession} --include gff3 || echo "Something went wrong!"
            if [[ ! -f ncbi_dataset.zip ]]; then
              echo "Exiting..."
              cd .. && rm -rf ${u}
              exit 1
            fi
            unzip ncbi_dataset.zip > /dev/null
            mv ${destdir} ../${accession}.gff
            cd ..
            rm -rf ${u} ; fi }

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
# counts features using AWK
awk -F '\t' '!/^#/ { counts++ } END { print "Total features detected: " counts }' ${accession}.gff 
# count individual features using AWK 
# loops over by ignoring comment lines and increases counter if compartment is encountered
awk -F '\t' '!/^#/ { counts[$3]++ } END { for(_ in counts) print counts[_] "\t" _ }' ${accession}.gff | sort -nr | head -10 > ${accession}.counts.txt
echo "Process has completed. Your resuls are ready here: ${accession}.counts.txt!"

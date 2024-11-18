#!/bin/bash 

set -eu
# CONSTANTS
READ_LENGTH=200
SEED=123131

# download genome 
accession_id=${1:-GCA_000240185.2}
coverage=${2:-10}

# isolate annoying ncbi dataset 
tmp=temp${RANDOM}
mkdir ${tmp}/
cd ${tmp}/

datasets download genome accession ${accession_id}
unzip -o ncbi_dataset.zip
mv ncbi_dataset/data/${accession_id}/*.fna .
accession=$(find . -type f -name "*.fna" | head -1)
mv ${accession} ..

cd ..
rm -rf ${tmp}
# remove temp file 
echo -e "Working on: ${accession}\n"
echo "########## Calculating file size ##############"

# calculate size 
stat -c "%s" ${accession}

# disk usage
du -sh ${accession}
echo -e "\n########### Calculating genome stats #################"

# calculate genome stats
seqkit stat ${accession}

# calculate genome size 
echo -e "\n############# Isolating genome size ###################"
genomeSize=$(seqkit stat GCA_000240185.2_ASM24018v2_genomic.fna | awk '{ gsub(/,/, ""); print $5}' | tail -1)
echo "Genome size of ${accession_id} estimated at: ${genomeSize}bp"

echo -e "\n############ Calculating chromosome names lengths ################"
# total chromosomes and length per chromosome
seqkit fx2tab --name --length ${accession}

# generate reads
echo -e "\n############### Generating sequence reads ##############"
echo -e "Specified Coverage: ${coverage}.\nSpecified Read Length: ${READ_LENGTH}.\nDetected genome size: ${genomeSize}.\nOUTPUT ---> reads/"

totalReads=$((coverage * genomeSize / READ_LENGTH))
echo -e "\nEstimated total reads for desired coverage ${coverage}x---> Total Reads = ${totalReads}."
echo -e "\nProceeding with calculation..."

if ! command -v wgsim > /dev/null; then
  echo -e "Please install samtools (wgsim) to proceed.\nExiting..."
  exit 1
fi

mkdir reads/
wgsim -S ${SEED} -N ${totalReads} -1 ${READ_LENGTH} -2 ${READ_LENGTH} -r 0 -R 0 -X 0 ${accession} reads/read1.fq reads/read2.fq

echo -e "\n############# Estimating read sizes #############"
du -sh reads/*

echo -e "\n############### Average read length ###############"
seqkit stat reads/* 2> /dev/null

echo -e "\n############### Compressing reads ################"
gzip -f reads/*
echo "Compression Status: Finished!"

echo -e "\n############## Calculating new compressed read sizes #################"
du -sh reads/*

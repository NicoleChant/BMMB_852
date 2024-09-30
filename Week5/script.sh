#!/bin/bash 

set -ex 

# download genome 
accession_id=GCA_000240185.2

# isolate annoying ncbi dataset 
tmp=temp${RANDOM}
mkdir ${tmp}/
cd ${tmp}/

datasets download genome accession ${accession_id}
unzip -o ncbi_dataset.zip
mv ncbi_dataset/data/${accession_id}/*.fna ..

cd ..
rm -rf ${tmp}
# remove temp file 
#
# calculate genome size 
stat -c "%s" GCA_000240185.2_ASM24018v2_genomic.fna 

# calculate genome stats
seqkit stat GCA_000240185.2_ASM24018v2_genomic.fna 

# total chromosomes and length per chromosome
seqkit fx2tab --name --length GCA_000240185.2_ASM24018v2_genomic.fna 

# generate reads
mkdir -p reads/
wgsim -N 284116 -1 200 -2 200 -r 0 -R 0 -X 0 GCA_000240185.2_ASM24018v2_genomic.fna reads/read1.fq reads/read2.fq

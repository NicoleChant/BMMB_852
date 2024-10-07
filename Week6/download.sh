#!/bin/bash 

set -xeu

SRR=SRR062634
# Download 1000 read pairs with fastq-dump into the reads directory
mkdir -p reads/
if [[ ! -f reads/${SRR}_1.fastq ]];
then
  fastq-dump -X 10000 -F --outdir reads --split-files ${SRR}
else
  echo "Already exists!"
fi

# Number of reads to sample
N=10000

# The output read names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

# Trimmed read names
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# The adapter sequence
ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# The reads directory
RDIR=reads

# The reports directory
PDIR=reports


# Make the necessary directories
mkdir -p ${RDIR} ${PDIR}

# Download the FASTQ file
fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR} 

# Run fastqc
fastqc -q -o ${PDIR} ${R1} ${R2}

# Run fastp and trim for quality
fastp --adapter_sequence=${ADAPTER} --cut_tail \
      -i ${R1} -I ${R2} -o ${T1} -O ${T2} 

# Run fastqc
fastqc -q -o ${PDIR} ${T1} ${T2}

# Run the multiqc from the menv environment on the reports directory
mamba run -n menv multiqc -o ${PDIR} ${PDIR}

# Variables
SRR=SRR15829420
ACC=NC_045512.2
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

N=10000  # Number of reads to simulate or download
T1=trimmed_${R1}
T2=trimmed_${R2}
ADAPTER=AGATCGGAAGAGC  # Replace with actual adapter sequence
PDIR=reports  # Output directory for FastQC and MultiQC reports
SEED=42  # Random seed for reproducibility
READ_LENGTH=150  # Read length for simulation
GENOME=${ACC}.fa

REF=refs/${ACC}.fa
SAM=align.sam
BAM=align.bam

# Default target
all: genome simulate download trim fastqc align

# Help target
usage:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  genome    - Download the genome"
	@echo "  simulate  - Simulate reads for the genome"
	@echo "  download  - Download reads from SRA"
	@echo "  trim      - Trim reads using fastp"
	@echo "  fastqc    - Run FastQC on trimmed reads"
	@echo "  multiqc   - Run MultiQC to summarize FastQC reports"
	@echo "  index   - Run BWA index to index reference genome"
	@echo "  align - Alings reads to reference genome and creates an index"

genome:
	echo "Chosen accession ${ACC}"
	mkdir -p refs
	datasets download virus genome accession ${ACC}
	unzip -n ncbi_dataset.zip
	mv ncbi_dataset/data/genomic.fna refs/${ACC}.fa
	rm -rf ncbi_dataset/

simulate: genome
	mkdir -p reads/
	wgsim -S ${SEED} -N ${N} -1 ${READ_LENGTH} -2 ${READ_LENGTH} -r 0 -R 0 -X 0 ${GENOME} ${R1} ${R2}

download:
	mkdir -p download_reads/
	fastq-dump --split-files ${SRR} -O download_reads/
	# prefetch ${SRR}
	# fasterq-dump --split-files --outdir reads/ ${SRR}

trim: 
	mkdir -p trimmed_reads/
	fastp --adapter_sequence=${ADAPTER} --cut_tail \
	      -i download_reads/${SRR}_1.fastq -I download_reads/${SRR}_2.fastq -o ${T1} -O ${T2}

fastqc: trim
	mkdir -p ${PDIR}/
	fastqc -q -o ${PDIR} ${T1} ${T2}

multiqc: fastqc
	mamba run -n menv multiqc -o ${PDIR} ${PDIR}

# Index the genome (needs to be done once)
index:
	bwa index ${REF}

# Align the reads and store results as a SAM file
align: index
	bwa mem ${REF} ${R1} ${R2} > ${SAM}
	cat ${SAM} | samtools sort > ${BAM}
	samtools index ${BAM}

stats:
	samtools flagstat ${BAM}

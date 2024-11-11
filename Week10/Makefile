# Variables
SRR=SRR15829420
ACC=NC_045512.2

R1=download_reads/$(SRR)_1.fastq
R2=download_reads/$(SRR)_2.fastq

T1=trimmed_$(R1)
T2=trimmed_$(R2)
ADAPTER=AGATCGGAAGAGC  # Replace with actual adapter sequence
PDIR=reports  # Output directory for FastQC and MultiQC reports
READ_LENGTH=150  # Read length for simulation
GENOME=$(ACC).fa

REF=refs/$(ACC).fa
SAM=align.sam
BAM=align.bam
PLOIDY=1

.PHONY: all usage genome download trim fastqc index bam clean call_variants call_variants_from_genotypes

# Default target
all: genome download trim fastqc align call_variants call_variants_from_genotypes

# Help target
usage:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  genome    - Download the genome"
	@echo "  simulate  - Simulate reads for the genome"
	@echo "  download  - Download reads from SRA"
	@echo "  trim      - Trim reads using fastp"
	@echo "  fastqc    - Run FastQC on trimmed reads"
	@echo "  index   - Run BWA index to index reference genome"
	@echo "  align - Alings reads to reference genome and creates an index"

genome:
	echo "Chosen accession $(ACC)"
	mkdir -p refs
	datasets download virus genome accession $(ACC)
	unzip -n ncbi_dataset.zip
	mv ncbi_dataset/data/genomic.fna refs/$(ACC).fa
	rm -rf ncbi_dataset/

download:
	mkdir -p download_reads/
	fastq-dump --split-files $(SRR) -O download_reads/
	# prefetch $(SRR)
	# fasterq-dump --split-files --outdir reads/ $(SRR)

trim: 
	mkdir -p trimmed_download_reads/
	fastp --adapter_sequence=$(ADAPTER) --cut_tail \
	      -i download_reads/$(SRR)_1.fastq -I download_reads/$(SRR)_2.fastq -o $(T1) -O $(T2)

fastqc:
	mkdir -p $(PDIR)/
	fastqc -q -o $(PDIR) $(T1) $(T2)

index:
	bwa index $(REF)

# Align the reads and store results as a SAM file
align:
	bwa mem $(REF) $(R1) $(R2) | samtools sort > $(SAM)
	samtools index $(BAM)

stats:
	samtools flagstat $(BAM)

call_variants:
	bcftools mpileup -Ov -f $(REF) $(BAM) > genotypes.vcf

call_variants_from_genotypes:
	bcftools call -mv -Ov --ploidy $(PLOIDY) genotypes.vcf > observed-mutations.vcf

# Variables
SRR=SRR15829420

# download Ebola
ACC=NC_002549.1
SNPEFF_DB=NC_045512.2

R1=download_reads/$(SRR)_1.fastq
R2=download_reads/$(SRR)_2.fastq
VCF=vcf
N=50000

T1=trimmed_$(R1)
T2=trimmed_$(R2)
ADAPTER=AGATCGGAAGAGC  # Replace with actual adapter sequence
PDIR=reports  # Output directory for FastQC and MultiQC reports
READ_LENGTH=150  # Read length for simulation
GENOME=$(ACC).fa

REF=refs/$(ACC).fa
SAM=$(SRR)_align.sam
BAM=$(SRR)_align.bam
SORTED_BAM=$(SRR)_align.sorted.bam
PLOIDY=1


SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all usage genome download trim fastqc bam clean call_variants call_variants_from_genotypes

usage:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  genome    - Download the genome"
	@echo "  simulate  - Simulate reads for the genome"
	@echo "  download  - Download reads from SRA"
	@echo "  trim      - Trim reads using fastp"
	@echo "  fastqc    - Run FastQC on trimmed reads"
	@echo "  align - Alings reads to reference genome and creates an index"
	@echo "  call_variants - Creates VCF file from aligned reads."
	@echo "  call_variants_from_genotype - "


genome:
	@echo "Chosen accession $(ACC)"
	mkdir -p refs
	@flock -n .download_lock \
	datasets download virus genome accession $(ACC) && \
	unzip -n ncbi_dataset.zip && \
	mv ncbi_dataset/data/genomic.fna refs/$(ACC).fa && \
	rm -rf ncbi_dataset/ || echo "Reference genome $(ACC) downloaded." \

all: download trim fastqc align call_variants call_variants_from_genotypes

download:
	@echo "Downloading reads from $(SRR) with coverage $(N)"
	mkdir -p download_reads/
	fastq-dump -X $(N) --split-files $(SRR) -O download_reads/
	# prefetch $(SRR)
	# fasterq-dump --split-files --outdir reads/ $(SRR)

trim: 
	mkdir -p trimmed_download_reads/
	fastp --adapter_sequence=$(ADAPTER) --cut_tail \
	      -i download_reads/$(SRR)_1.fastq -I download_reads/$(SRR)_2.fastq \
				-o $(T1) -O $(T2)

fastqc:
	mkdir -p $(PDIR)/
	fastqc -q -o $(PDIR) $(T1) $(T2)

align:
	@mkdir -p aligned
	bwa index $(REF)
	bwa mem $(REF) $(T1) $(T2) > aligned/$(BAM)
	samtools sort aligned/$(BAM) -o aligned/$(SORTED_BAM)
	samtools index aligned/$(SORTED_BAM)

stats:
	samtools flagstat aligned/$(BAM)

call_variants:
	@mkdir -p $(VCF)/
	bcftools mpileup -Ov -f $(REF) aligned/$(SORTED_BAM) > $(VCF)/$(SRR)_genotypes.vcf

call_variants_from_genotypes:
	bcftools call -mv -Ov --ploidy $(PLOIDY) $(VCF)/$(SRR)_genotypes.vcf > $(VCF)/$(SRR)_observed-mutations.vcf
	bcftools sort $(VCF)/$(SRR)_observed-mutations.vcf -Oz -o $(VCF)/$(SRR)_observed-mutations.sorted.vcf
	bcftools index -t $(VCF)/$(SRR)_observed-mutations.sorted.vcf
	# bgzip $(VCF)/$(SRR)_observed-mutations.sorted.vcf

JOBS=3
# download Ebola
ACC=NC_002549.1
SNPEFF_DB=NC_045512.2

R1=download_reads/$(SRR)_1.fastq
R2=download_reads/$(SRR)_2.fastq
VCF=vcf

DATASET_READS="design.csv"

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
BIOPROJECT=PRJNA257197
THREADS=2

.PHONY: genome process_reads merge

SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

all: genome process_reads merge

create_design:
	@echo "Downloading project files..."
	bio search $(BIOPROJECT) -H --csv | csvtk cut -f run_accession,sample_alias | head > $(DATASET_READS)

genome:
	make genome -f pipeline.mk ACC=$(ACC)

process_reads:
	@echo "Processing reads in parallel using $(JOBS) jobs."
	# cat $(DATASET_READS) | parallel --colsep , --header -j $(JOBS) : make all -f pipeline.mk SRR={run} COVERAGE={coverage}
	./process_reads.sh $(DATASET_READS) $(JOBS)

merge:
	@echo "Merging VCF files"
	echo $(VCF)
	mkdir -p $(VCF)
	ulimit -Sn 1024
	find $(VCF) -maxdepth 1 -type f -name "*observed-mutations.sorted.vcf" > vcf_files.txt
	bcftools merge -Ov \
		--threads $(THREADS) \
		--file-list vcf_files.txt \
		-Oz \
		-o $(VCF)/merged.vcf.gz

clean:
	@echo "Invoking cleaning magic!"
	rm -rf $(REF)
	rm -rf $(PDIR)
	rm -rf $(VCF)
	rm -rf trimmed_download_reads/ 
	rm -rf download_reads/
	rm -rf aligned/

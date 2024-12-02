# Variables
SRR=SRR15829420
ACC=NC_045512.2
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
SAM=align.sam
BAM=align.bam
SORTED_BAM=align.sorted.bam
PLOIDY=1


.PHONY: all usage genome download trim fastqc index bam clean call_variants call_variants_from_genotypes

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
	@echo "  call_variants - Creates VCF file from aligned reads."
	@echo "  call_variants_from_genotype - "
	@echo "  snpeff - Variant Effect software against generated VCF file; mutation analytics"


all: genome download trim fastqc index align call_variants call_variants_from_genotypes snpeff

genome:
	echo "Chosen accession $(ACC)"
	mkdir -p refs
	datasets download virus genome accession $(ACC)
	unzip -n ncbi_dataset.zip
	mv ncbi_dataset/data/genomic.fna refs/$(ACC).fa
	rm -rf ncbi_dataset/

download:
	mkdir -p download_reads/
	fastq-dump -X $(N) --split-files $(SRR) -O download_reads/
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
	bwa mem $(REF) $(T1) $(T2) > $(BAM)
	samtools sort $(BAM) -o $(SORTED_BAM)
	samtools index $(SORTED_BAM)

stats:
	samtools flagstat $(BAM)

call_variants:
	@mkdir -p $(VCF)/
	bcftools mpileup -Ov -f $(REF) $(SORTED_BAM) > $(VCF)/genotypes.vcf

call_variants_from_genotypes:
	bcftools call -mv -Ov --ploidy $(PLOIDY) $(VCF)/genotypes.vcf > $(VCF)/observed-mutations.vcf

snpeff:
	@mkdir -p snpeff_refs/
	snpeff download $(SNPEFF_DB)
	snpeff -v $(SNPEFF_DB) $(VCF)/genotypes.vcf > snpeff_$(REF).vcf

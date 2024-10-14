# Variables
SRR = SRR17400382 
SRR = SRR062634
ACC = NC_045512.2
R1 = reads/read1.fq
R2 = reads/read2.fq

N = 1000000  # Number of reads to simulate or download
T1 = trimmed_$(R1)
T2 = trimmed_$(R2)
ADAPTER = AGATCGGAAGAGC  # Replace with actual adapter sequence
PDIR = reports  # Output directory for FastQC and MultiQC reports
SEED = 42  # Random seed for reproducibility
READ_LENGTH = 150  # Read length for simulation
GENOME = $(ACC).fa
# Default target
all: usage

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

genome:
	echo $(ACC)
	datasets download virus genome accession $(ACC)
	unzip -o ncbi_dataset.zip
	mv ncbi_dataset/data/genomic.fna $(ACC).fa
	rm -rf ncbi_dataset/

simulate: genome
	mkdir -p reads/
	wgsim -S $(SEED) -N $(N) -1 $(READ_LENGTH) -2 $(READ_LENGTH) -r 0 -R 0 -X 0 $(GENOME) $(R1) $(R2)

download:
	prefetch $(SRR)
	fasterq-dump --split-files $(SRR)

trim: download
	fastp --adapter_sequence=$(ADAPTER) --cut_tail \
	      -i $(R1) -o $(T1)

fastqc: trim
	mkdir -p reads/
	mkdir -p trimmed_reads/
	fastqc -q -o $(PDIR) $(T1) $(T2)

multiqc: fastqc
	mamba run -n menv multiqc -o $(PDIR) $(PDIR)

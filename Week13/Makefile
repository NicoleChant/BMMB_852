DESIGN=design.csv
TOTAL=400000
REF=refs/Mus_musculus.GRCm39.dna.chromosome.19.fa
GTF=gtf/Mus_musculus.GRCm39.109.chr19.gtf
BAM=bam
COUNTS_RE=counts.reformed.txt

.PHONY: run count reformat clean

SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

all: run count

run:
	@mkdir -p $(BAM)/
	cat $(DESIGN) | parallel --lb --header : --colsep , \
                 make -f process.mk all \
		 REF=$(REF) \
                 R1=reads_$(TOTAL)/{sample}_1.fastq  \
		 R2=reads_$(TOTAL)/{sample}_2.fastq  \
                 BAM=$(BAM)/{sample}.bam

count:
	cat $(DESIGN) | \
    		parallel --header : --colsep , -k \
    		echo bam/{sample}.bam | \
    		parallel -v --lb --xargs \
    		featureCounts -a $(GTF) -o counts.txt {}

reformat:
	Rscript src/r/format_featurecounts.r -c counts.txt -o $(COUNTS_RE)

clean:
	rm -rf bam/


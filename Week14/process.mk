TOTAL=400000
DIR=reads_$(TOTAL)
R1=$(DIR)/SRR7657880_1.fastq
R2=$(DIR)/SRR7657880_2.fastq
BAM=bam/SRR7657880.bam
DESIGN=design.csv
REF=refs/Mus_musculus.GRCm39.dna.chromosome.19.fa
COUNTS=counts.txt

.PHONY: genome process_reads merge

SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

all: align wiggle

index:
	make -f src/run/hisat2.mk index REF=$(REF)

align: 
	make -f src/run/hisat2.mk \
                 REF=$(REF) \
                 R1=$(R1) \
		 R2=$(R2) \
                 BAM=$(BAM) \
                 run

wiggle:
	make -f src/run/wiggle.mk \
        REF=$(REF) \
        BAM=$(BAM) \
        run


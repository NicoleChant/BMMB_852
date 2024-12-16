DESIGN=design.csv
TOTAL=400000
REF=refs/Mus_musculus.GRCm39.dna.chromosome.19.fa
GTF=gtf/Mus_musculus.GRCm39.109.chr19.gtf
BAM=bam
COUNTS_RE=counts.reformed.txt
DESEQ=deseq.csv
PLOT_RESULTS=plots

.PHONY: run count reformat clean

SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

all: run count reformat deseq2 to_plot_or_to_not

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
	#	Rscript src/r/format_featurecounts.r -c counts.txt -o $(COUNTS_RE)
	Rscript src/r/format_featurecounts.r -c counts.txt -t tx2gene.csv -o $(COUNTS_RE)

deseq2: 
	mkdir -p results
	conda run -n stats Rscript src/r/deseq2.r -d $(DESIGN) -c $(COUNTS_RE) -o $(DESEQ) -s sample 
	
to_plot_or_to_not:
	mkdir -p $(PLOT_RESULTS)
	conda run -n stats Rscript src/r/plot_heatmap.r -d $(DESIGN) -c $(DESEQ) -o $(PLOT_RESULTS)/heatmap.pdf
	conda run -n stats Rscript src/r/plot_pca.r -d $(DESIGN) -c $(COUNTS_RE) -f sample -o $(PLOT_RESULTS)/pca_samples.pdf
	conda run -n stats src/r/plot_pca.r -d $(DESIGN) -c $(COUNTS_RE) -f group -o $(PLOT_RESULTS)/pca_groups.pdf
	echo "DONE!"

clean:
	rm -rf bam/


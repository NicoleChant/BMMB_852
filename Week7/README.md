# Week 6

## Introduction

This Makefile combines read simulation, downloading, trimming, and quality control into a single pipeline. It uses `fastp` for trimming reads and `FastQC` for quality checks, and summarizes the results with `MultiQC`.

### Targets

- **usage**: Prints the help message, showing available targets.
- **genome**: Downloads the genome file from Ensembl.
- **simulate**: Simulates paired-end reads using `wgsim`.
- **download**: Downloads reads from SRA.
- **trim**: Trims reads using `fastp` with adapter sequence trimming.
- **fastqc**: Runs `FastQC` on the trimmed reads.
- **multiqc**: Runs `MultiQC` to aggregate the FastQC reports.

### How to Use

To use the Makefile, run the following commands based on the task you want to perform:

```bash
make genome        # Download the genome
make simulate      # Simulate reads for the genome
make download      # Download reads from SRA
make trim          # Trim reads using fastp
make fastqc        # Run FastQC on trimmed reads
make multiqc       # Run MultiQC to summarize FastQC reports
```

You can skip downloading the genome using `make genome`, since by directly using simulate command, the given genome will be downloaded automatically. 

```
make simulate
```

With `make download` we can download SRR reads. Finally, by using `make fastqc` we can trim the reads and finally generate a report using multiqc.

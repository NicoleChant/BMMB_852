# Week 9

I downloaded the following SRR:

```
https://www.ncbi.nlm.nih.gov/sra/SRR15829420
```

It's Whole Genome Sequencing of SARS COVID-2 using Illumina MiniSeq reads.

The bioproject is the following:
```
PRJNA741723
```

The sample is the Delta variant in Bangladeshi sample.

![corona](https://media.giphy.com/media/MCAFTO4btHOaiNRO1k/giphy.gif?cid=790b7611995r701whaqprrihc3d36dnvcti6v3e33jdsuujm&ep=v1_gifs_search&rid=giphy.gif&ct=g)
We will align this to the reference genome of SARS COVID-2 with the following accession ID:

## Introduction

This Makefile combines read simulation, downloading, trimming, and quality control into a single pipeline. It uses `fastp` for trimming reads and `FastQC` for quality checks, and summarizes the results with `MultiQC`.
The reference genome for SARS COVID-2 is the following:

```
NC_045512.2
```

For information about the taxonomy can be found here:

[link](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=2697049)

This is a special viral genome which we can download with:

```
datasets download virus genome accession ${ACC}
```

Using the Makefile from the previous week I created a file:

```
align.bam
```

I will answer the following questions:

- How many reads did not align with the reference genome? 
- How many primary, secondary, and supplementary alignments are in the BAM file?
- How many properly-paired alignments on the reverse strand are formed by reads
contained in the first pair?
- Make a new BAM file that contains only the properly paired primary alignments with 
a mapping quality over 10.
- Compare the flagstats for your original and your filtered BAM file.


#### How many reads did not align with the reference genome?

We will use the view command from samtools to get the cound of reads that did not align:

```
samtools view -c -f 4 align.bam
```

Explanation of flags:

- c: provides the counts
- f 4: specifies to count reads that were not mapped (i.e. didn't align to the reference)

The output was:

```
samtools view -c -f 4 align.bam
0
```

Thus, all my reads were aligned properly.

#### Question 2

- How many primary, secondary, and supplementary alignments are in the BAM file?

```
samtools view -c -F 0x900 align.bam  # Primary alignments
samtools view -c -f 0x100 align.bam  # Secondary alignments
samtools view -c -f 0x800 align.bam  # Supplementary alignments
```

Output of the commands above:
```
20000
0
0
```

All alignments are primary.

#### Question 3

- How many properly-paired alignments on the reverse strand are formed by reads contained in the first pair?

```
samtools view -c -f 66 align.bam
```

*Explanation*

The flag -f 66 combines 0x2 which stands for *properly paired* 
and 0x40 which stands for *first in pair* with 
0x10 which stands for *reverse strand*.

Output:
```
10000
```

#### Question 4

- Make a new BAM file that contains only the porperly paired primary alignments with a mapping quality over 10

```
samtools view -b -q 10 -f 2 -F 0x904 align.bam > filtered.bam
```

*Explanation*

The flag -q 10 filters for mapping quality greater than 10, while the 
-f 2 ensures reads are properly paired. Moreover, -b outputs in BAM format and
-F 0x904 excludes secondary and supplementary alignments.

#### Question 5

- Compare the flagstats for your original and your filtered BAM file.

The flagstat of samtools package provides a summary of alignments, 
including total reads, mapped reads, properly paired reads.

By using the following command:

```
samtools flagstat align.bam
samtools flagstat filtered.bam
```

Output for align.bam:
```
20000 + 0 in total (QC-passed reads + QC-failed reads)
20000 + 0 primary
0 + 0 secondary
0 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
20000 + 0 mapped (100.00% : N/A)
20000 + 0 primary mapped (100.00% : N/A)
20000 + 0 paired in sequencing
10000 + 0 read1
10000 + 0 read2
20000 + 0 properly paired (100.00% : N/A)
20000 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)jj
```

Output for filtered.bam:
```
20000 + 0 in total (QC-passed reads + QC-failed reads)
20000 + 0 primary
0 + 0 secondary
0 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
20000 + 0 mapped (100.00% : N/A)
20000 + 0 primary mapped (100.00% : N/A)
20000 + 0 paired in sequencing
10000 + 0 read1
10000 + 0 read2
20000 + 0 properly paired (100.00% : N/A)
20000 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

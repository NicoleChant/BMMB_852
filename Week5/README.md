## Week 5

Please note, the pipeline used to generate this analysis is present here:

[pipeline](https://raw.githubusercontent.com/NicoleChant/BMMB_852/refs/heads/master/Week5/pipeline_week4.sh)


Use as follows:

```
bash pipeline_week4.sh <your_accession_id>
```

For instance,

```
bash pipeline_week4.sh 
```

works on a default assembly id.

### Task 1

*Select a genome, then download the corresponding FASTA file.*

I have chosen *Klebsiella pneumoniae*. The corresponding genbank accession id is: GCA_000240185.2.

I will store this as a variable in bash.

```
accession_id=GCA_000240185.2
```

We can download it by using
```
datasets download genome accession ${accession_id}
```

After unzipping and moving the fasta file out of the ncbi zipped directory I will answer the following questions:

- The size of the file

We can use 
```
ls -h -s 
```

```
stat -c "%s" GCA_000240185.2_ASM24018v2_genomic.fna 
5753994
```

Another alternative would be to count the disk usage of the file, which would be slightly different than the above commands:

```
du -h GCA_000240185.2_ASM24018v2_genomic.fna 
5.5M	GCA_000240185.2_ASM24018v2_genomic.fna
```

- The total size of the genome

We can find the total size of the genome by utilizing the seqkit stat command. I copy-paste the output of the command below:

```
seqkit stat GCA_000240185.2_ASM24018v2_genomic.fna 
file                                    format  type  num_seqs    sum_len  min_len    avg_len    max_len
GCA_000240185.2_ASM24018v2_genomic.fna  FASTA   DNA          7  5,682,322    1,308  811,760.3  5,333,942
```

Thus, the total genome size is equal to 5,682,322 bp.

- The number of chromosomes in the genome

The previous command also prints out the total number of chromosomes, under the *num_seqs* column. Hence, the answer is 7. 
However, a simple grep command suffices:

```
grep -a '^>' GCA_000240185.2_ASM24018v2_genomic.fna  | wc -l
7
```

- The name (id) and length of each chromosome in the genome.

We can use seqkit fx2tab command as follows:

```
seqkit fx2tab --name --length GCA_000240185.2_ASM24018v2_genomic.fna 
CP003200.1 Klebsiella pneumoniae subsp. pneumoniae HS11286, complete genome	5333942
CP003223.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS1, complete sequence	122799
CP003224.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS2, complete sequence	111195
CP003225.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS3, complete sequence	105974
CP003226.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS4, complete sequence	3751
CP003227.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS5, complete sequence	3353
CP003228.1 Klebsiella pneumoniae subsp. pneumoniae HS11286 plasmid pKPHS6, complete sequence	1308
```

### Task 2

*Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x.*

Genome size is equal to: 5,682,322 bp. In order to achiveme 10x coverage we need:

$Total Reads = \frac{Genome Size \times Coverage}{ Read Length }$

Thus, by arbitarily setting Read Length equal to 200bp, we need approximately: 284,116 reads.

I will use the following command with wgsim:

# Simulate with no errors and no mutations

```
mkdir -p reads/
wgsim -N 284116 -1 200 -2 200 -r 0 -R 0 -X 0 GCA_000240185.2_ASM24018v2_genomic.fna reads/read1.fq reads/read2.fq
[wgsim] seed = 1727667734
[wgsim_core] calculating the total length of the reference sequence...
[wgsim_core] 7 sequences, total length: 5682322

```

- How many reads have you generated?

I have generated, 284117 reads. For instance:

```
grep -a '^@' read2.fq  | wc -l
284117
```
- What is the average read length?

- How big are the FASTQ files?

```
du -sh *
123M	read1.fq
123M	read2.fq
```

- Compress the files and report how much space that saves.

```
du -sh *
23M	read1.fq.gz
23M	read2.fq.gz
```

We save 200M space by compressing both of the read files.

- Discuss whether you could get the same coverage with different parameter settings (read length vs. read number).

Of course. We chose arbitrarily the read length to determine the read number. It's a function with two independent variables, so we can specify any read length which 
corresponds to a particular read number given the formula above.

### Task 3 

*How much data would be generated when covering the Yeast,  the Drosophila or the Human genome at 30x?*

Now imagine that instead of your genome, each instrument generated reads that cover the Yeast, Drosophila, 
and Human genomes at 30x coverage (separate runs for each organism). You don't have to run the tool all you need is to estimate.
Using the information you've obtained in the previous points, for each of the organisms, 
estimate the size of the FASTA file that holds the genome, the number of FASTQ reads needed for 30x, 
and the size of the FASTQ files before and after compression.


Please note, each genome, depending on the version has different Genome Size. I will choose Homo sapiens hg38, here:

[homosapiens](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.26/)

hg38 version of Homo sapiens has genome size equal to 3.1 Gb.




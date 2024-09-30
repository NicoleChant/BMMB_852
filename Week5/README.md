## Week 5

Please note, the pipeline used to generate this analysis is present here:

[pipeline](https://raw.githubusercontent.com/NicoleChant/BMMB_852/refs/heads/master/Week5/pipeline_week4.sh)

Use as follows:

```
bash pipeline_week4.sh <your_accession_id>
```

Before running make sure to have wgsim installed and remove any directory named *reads/* because this is where the
read simulations will be stored. On linux you can use:

```
sudo apt-get install samtools
```

Check the version:
```
wgsim --version
```

For instance, you can try the following to generate my results:

```
wget https://raw.githubusercontent.com/NicoleChant/BMMB_852/refs/heads/master/Week5/pipeline_week4.sh
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

Since, it's decided deterministically from read length that is being given as input to
wgsim, due to the parameters I used (non-random), it's 200bp as I specified in the beginning.

But we can check, by using:

```
seqkit stat reads/*
```

The output is:
```
processed files:  2 / 2 [======================================] ETA: 0s. done
file            format  type  num_seqs     sum_len  min_len  avg_len  max_len
reads/read1.fq  FASTQ   DNA    284,117  56,823,400      200      200      200
reads/read2.fq  FASTQ   DNA    284,117  56,823,400      200      200      200
```

Hence, the average read is 200bp.

- How big are the FASTQ files?

```
du -sh reads/*
123M	reads/read1.fq
123M	reads/read2.fq
```

- Compress the files and report how much space that saves.

```
du -sh reads/*
23M	reads/read1.fq.gz
23M	reads/read2.fq.gz
```

We save 200M space by compressing both of the read files. Thus, we had approximately, 81,3% decrease in disk usage by compressing the read files.

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
[drosophila](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001215.4/)
[yeast](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000146045.2/)

- hg38 version of Homo sapiens has genome size equal to: 3.1 Gb.
- Drosophila version is equal to: 143.7 Mb.
- Yeast is equal to: 12.1 Mb.

For the hg38 we have: Genome Size = 3,100,000,000 and consequently, assuming 150 read length, the total number of reads we need 
to achieve 30x coverage is equal to:

$Total Reads = \frac{G \times C}{ 150 bp } = \frac{ 3,100,000,000 \times 30 }{ 150 } = 6200000000$

The entire fasta file that holds the genome must be approximately equal to the genome size plus the additional headers and new line characters.

We note that in a FASTQ file for each read there are four associated lines, i.e.

```
@CP003200.1_3505156_3505592_7:0:0_5:0:0_0/1
ATCTACGGCCTCTTCTCCTGGCCGTGGCTGGGGTTTGTCGGCTCCGGGCTTGGGCTGACCATTGCCCGCTATATTGGCGCGATAGCCACGATCTGGGTGCTGATGGTGGGCCTCAATCCGGCGCTGCTGCTGTCGCTGAAGGGTTACTTCAAACCCTTTAACTTCGCCATTATCTGGGAGGTGATGGGGATCGTCATCCC
+
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
```

To estimate the byte size of a FASTQ file we need to observe that approximately:

```
FASTQ Bytes = Total Reads X ( 2 X READ LENGTH + 1 + Header Length + 4)
```

This formula is based on the fact that for each read with also have the quality score, plus 1 byte for the separator line and the overhead for the header. 
Additionally, we have 4 bytes for the newline characters that we must add on each read, one corresponding to each line of the read (read has 4 lines in total).
I am not sure how to estimate the header. I would say it's maximum 50 characters, so let's settle at 43 bytes (My example has 39 longest header)?

Thus, in our example, using the formula above the answer is equal to:

```
FASTQ Bytes = 620000 X ( 2 X 150 + 1 + 4 + 43 ) = 215.76 Gb
```

Note that we have two reads, but I will do all the calculations on just the one of two.

We noticed that compressing using gzip (with normal compression mode - default), reduces the disk usage by 81%. Assuming approximately 81% (it really depends), 
Note that we could use another tool for compression more targeted to genomic sequences rather than gzip. 
I would suggest that after compression with gzip using default flag, the total bytesize would be reduced to:

```
Compressed FASTQ Bytes = 215.76 Gb * 0.19 = 40.994 Gb (81% decrease)
```

Okay for now I am not sure about my previous calculations. Let me try to compare my logic with the output from the previous tasks.

In my case I used 200bp read lengths for Klebsiella pneumoniae genome. 
Thus, assuming average header length around 43bp long, the fastq size must be approximately:

```
>>> 284117 * ( 2 * 200 + 43 + 4 + 1)
127284416
```

Using stat command I find:
```
stat read1.fq  | grep -a 'Size' | awk '{ print $1 $2 }'
Size:128142575
```

Which is very close to the one derived by my formula. I assume the difference lies within the varying header sizes.
Furthermore, by compressing using gzip I observe that:

```
>>> 0.19 * 128142575
24347089.25
>>> 23200583 
23200583
```

Applying the same calculations to Drosophila and Yeast, we obtain:

- Drosophila version is equal to: 143.7 Mb.
- Yeast is equal to: 12.1 Mb.

$Total Reads Drosophila = \frac{G \times C}{ 150 bp } = \frac{ 143,700,000 \times 30 }{ 150 } = 28,740,000$
$Total Reads Yeast = \frac{G \times C}{ 150 bp } = \frac{ 12,100,000 \times 30 }{ 150 } = 2,420,000$

$FastQ Size Drosophila = Total Reads Drosophila \times ( 2 \times 150 + 4 + 1 + 43) = 10 Gb$
$FastQ Size Yeast = Total Reads Yeast \times ( 2 \times 150 + 4 + 1 + 43) = 0.84 Gb$

$FastQ Size Drosophila Compressed = 0.19 \times FastQ Mb Drosophila = 1.9 Gb$
$FastQ Size Yeast Compressed = 0.19 \times FastQ Mb Yeast = 160.01 Mb$

I am not sure about my calculations but I tried to follow a specific line thought. 

Thank you for reading this far!

**The End!** 🪄

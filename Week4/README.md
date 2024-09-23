# Week 4 


### Part 1 

Bash script can be download here:

```
wget https://raw.githubusercontent.com/NicoleChant/BMMB_852/refs/heads/master/Week4/feature_counter.sh
```

#### Usage

Make sure you have installed ncbi datasets CLI tool.

You can use the scripts as follows:

```
bash feature_counter.sh GCF_<unique_id>.<version?>
```

For instance,

```
bash feature_counter.sh GCF_000001405.40
```

The script will try to detect if the file exists on the present working directory.

Otherwise, it will create a temporary file and download the provided assembly within that directory.

It will name correctly the contents, and finally, it will count the features of the GFF file using AWK.

Here is a sample of the output:

```
Detected accession GCF_000001405.40.
Processing accession GCF_000001405.40.
Red Alert! Red Alert!
Unable to detect accession. Initializing download protocol 27241

Collecting 1 genome record [================================================] 100% 1/1
Downloading: ncbi_dataset.zip    77.8MB valid zip structure -- files not checked
Validating package [================================================] 100% 5/5
GFF File has been succesfully downloaded for accession GCF_000001405.40.
Food is in the oven. Please wait...
Total features detected: 4903918
Process has completed. Your resuls are ready here: GCF_000001405.40.counts.txt!
```

#### Peer Review Validation

I have chosen to validate the feature counts of GFF file from Week 2. I will choose Hanh's assembly Drosophila melanogaster.

```
wget https://ftp.ensembl.org/pub/current_gff3/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.46.112.gff3.gz
```

Please note, that my script downloads the assembly if it doesn't exist and works only with refseq or genbank assembly accessions. 
So it will not work with this link or full organism names.

To make it work, I will find Drosophila melanogaster on NCBI. A quick google search will yield the following:

- GCA_000001215.4	
- GCF_000001215.4

Now, I can use my script to download and extract the feature counts from Drosophila melanogaster accession ID. I will use refseq ID.

Running:

```
bash feature_counter.sh GCF_000001215.4
```

yields, the following:

```
190710	exon
163319	CDS
30802	mRNA
17537	gene
5734	mobile_genetic_element
2374	lnc_RNA
1870	region
621	antisense_RNA
485	miRNA
339	pseudogene
317	tRNA
270	snoRNA
266	primary_transcript
134	rRNA
60	ncRNA
32	snRNA
2	SRP_RNA
2	RNase_P_RNA
1	sequence_feature
1	RNase_MRP_RNA
```

The results differ due to different annotations used by refseq and ensemble versions. Probably, versions are also different.

For that reason, I made a second script that works with ftp links that can be found here:

```

```

Now, by running:


```
bash feature_counter.v2.sh 
```

I obtain the same results as Hahn. I post the text below for verification purposes:

```
196662	exon
163268	CDS
46782	five_prime_UTR
33738	three_prime_UTR
30799	mRNA
13986	gene
5898	transposable_element_gene
5898	transposable_element
4054	ncRNA_gene
3051	ncRNA
```

Hanhs results were:

```
cut -f 3 Drosophila_melanogaster.BDGP6.46.112.gff3 | sort | uniq -c | sort -nr | head -10

196662 exon
163268 CDS
46782 five_prime_UTR
33738 three_prime_UTR
30799 mRNA
26148 ###
13986 gene
5898 transposable_element_gene
5898 transposable_element
4054 ncRNA_gene
```

#### Errors


If no assembly is provided the program will exit. For instance,


```
bash feature_counter.sh 
No accession was provided. Exiting...
```

Additionally, if the accession does not exist or the accession number is wrong, then the program will exit.

### Part 2

- Choose a feature: I have chosen exons.

By running:

```
bio explain exon --lineage
```
We find out that exon has the following sequence ontology SO:0000147.

The parents and childrens on exon provided by the bio explain command are displayed below:

*Parents*:
```
SO:0000110  sequence_feature
  SO:0000001  region
    SO:0001411  biological_region
      SO:0000833  transcript_region
```

*Children*:
- coding_exon 
- noncoding_exon 
- interior_exon 
- decayed_exon (non_functional_homolog_of)
- pseudogenic_exon (non_functional_homolog_of)
- exon_region (part_of)
- exon_of_single_exon_gene 


The definition of the exon is:

```
A region of the transcript sequence within a gene which is not removed from the primary RNA transcript by RNA splicing.
```

Obviously, an exon must be part of an mRNA transcript. Thus, transcript is the first parent. And transcripts belong to broader biological regions (i.e. genes), 
thus this is the grandparent up to chromosome (region) and sequence_features (root of the tree).

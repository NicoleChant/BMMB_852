# Download, Generate and Visualize GFF files in IGV 



Organism Accession ID: GCF_000005845.2

GFF: GCF_000005845.2_ASM584v2_genomic.gff.gz 
FASTA: GCF_000005845.2_ASM584v2_genomic.gff.gz 

- Use IGV to visualize the annotations relative to the genome 

#### Download


```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz  
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz  
```

#### Fetch genes from GFF File

```
awk -F '\t' ' $3 == "gene" { print $0 }' GCF_000005845.2_ASM584v2_genomic.gff > GCF_000005845.2_ASM584v2_genomic.genes.gff
```


#### Visualize in IGV 


![igv_image](IGV_genes.png)


#### Custom GFF File 


A custom GFF file was created:

```
GCF_000005845.2_ASM584v2_genomic.new.gff 
```

using random coordinates.

The result on IGV:

![igv_new[(IGV_new_gff.png)

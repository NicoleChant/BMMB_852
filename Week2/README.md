# Week 2


### File Download (GFF)

```
wget ftp.ensembl.org/pub/current_gff3/sus_scrofa/Sus_scrofa.Sscrofa11.1.112.gff3.gz
```

### About the Organism

Sus scrofa is the wild boar (Sus scrofa), also known as the wild pig. It's nuclear genome is composed of 18 chromosomes, 16 autosomal and 2 non-autosomal.

### Total Features 

```
cat $file | grep -v '#' | wc -l
```

### Total Sequence Regions 

```
awk -F '\t' '/^##sequence-region/ { count++ } END { print count }' $file
```

### Total Genes 

```
awk -F '\t' '{ if ($3 ~ "gene") count++ } END { print count }' $file
```

### Top-ten most annotated feature types

```
awk '!/^#/ { counts[$3]++ } END { for (_ in counts) print counts[_] "\t" _ }' $file | sort -nr | head -10
```

### Is the organism complete?

It is not. It has many gaps that's why there are so many scaffolds sequence regions.

#!/bin/bash

set -e
file=$(basename $1 .gz)

if [[ ! -f $file ]]; then
    if ! wget "$1"; then
        echo "Download failed."
        exit 1
    fi
    gunzip $file.gz
    echo "File has been downloaded!"
else
    echo "File already exists!"
fi

features=$(cat $file | grep -v '#' | wc -l)
echo "Total features: ${features}."

regions=$(awk -F '\t' '/^##sequence-region/ { count++ } END { print count }' $file)
echo "Total sequence regions: ${regions}."

genes=$(awk -F '\t' '{ if ($3 ~ "gene") count++ } END { print count }' $file)
echo "Total genes: ${genes}."

topTen=$(awk '!/^#/ { counts[$3]++ } END { for (_ in counts) print counts[_] "\t" _ }' $file | sort -nr | head -10)
echo -e "Top-ten most annotated feature types:\n${topTen}"

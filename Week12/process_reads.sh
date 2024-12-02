#!/usr/bin/bash

DATASET=$1
JOBS=$2
DELAY=2

cat $1 | parallel --verbose \
                  --delay ${DELAY} \
                  --jobs ${JOBS} \
                  --colsep , --header : make all -f pipeline.mk SRR={run_accession} N={coverage}


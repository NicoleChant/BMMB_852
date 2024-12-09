#!/bin/bash

while read -r LINE;
do
	sbatch download_study.sh $LINE	
done < SRR_Acc_List.txt

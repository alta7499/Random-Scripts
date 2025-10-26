#!/bin/bash
### run the Pre-run script before running this script to generate necessary files.
### change the path as necessary
### provide names of the files without vcf.gz extension
### usage: ./run_ihs.sh input_vcf
### run each chromosome individually

VCF=$1

#run_ihs
selscan --ihs --vcf $VCF.vcf.gz --map $VCF.map --out $VCF.out --maf 0.01 --threads 10

norm --ihs --files $VCF.ihs.out --bp-win 100000

#!/bin/bash
### run the Pre-run script before running this script to generate necessary files.
### change the path as necessary
### provide names of the files without vcf.gz extension
### usage: ./run_xpehh.sh input_vcf reference_vcf output_vcf

VCF=$1
REF_VCF=$2
chr=$3

#run xpehh
selscan --xpehh --vcf $VCF.vcf.gz --vcf-ref $REF_VCF.vcf.gz --map $VCF.map --maf 0.01 --out $VCF.out --threads 10

norm --xpehh --files $VCF.ihs.out --bp-win 100000

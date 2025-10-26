#!/bin/bash
### This is a script to QC VCF files before running selscan (for both ihs and xpehh)
### This script will perform :
#	1. separating the VCF into multiple chromosome, 1 - 22.
#	2. Keeps only SNPs, no multi allelics and no Indels.
#	3. generate a map fie (in centimorgans) for the SNPs. required by selscan.
### usage: ./Pre_run_selscan.sh vcf_file_without_vcf.gz_extension
### Use the output with "selscan.vcf.gz" to run the next script.

VCF=$1

#split into individual chromosomes
seq 1 22 | xargs -I {} -P 15 bcftools view -t {} $VCF.vcf.gz -Oz -o $VCF.chr{}.vcf.gz
seq 1 22 | xargs -I {} -P 15 bcftools index $VCF.chr{}.vcf.gz

#keep only bialelic snps
seq 1 22 | xargs -I {} -P 15 bcftools view -M 2 -m 2 -v snps $VCF.chr{}.vcf.gz -Oz -o $VCF.chr{}.selscan.vcf.gz
seq 1 22 | xargs -I {} -P 15 bcftools index $VCF.chr{}.selscan.vcf.gz

#Create mapfiles
seq 1 22 | xargs -I {} -P 15 plink --keep-allele-order --vcf $VCF.chr{}.selscan.vcf.gz --cm-map MAP/chr{}.b37.gmap {} --recode --out $VCF.chr{}.selscan

#!/bin/bash

#split into individual chromosomes
seq 1 22 | xargs -I {} -P 15 bcftools view -t {} $VCF.vcf.gz -Oz -o $VCF.chr{}.vcf.gz
seq 1 22 | xargs -I {} -P 15 bcftools index $VCF.chr{}.vcf.gz

#keep only bialelic snps
seq 1 22 | xargs -I {} -P 15 bcftools view -M 2 -m 2 -v snps $VCF.chr{}.vcf.gz -Oz -o $VCF.chr{}.selscan.vcf.gz
seq 1 22 | xargs -I {} -P 15 bcftools index $VCF.chr{}.selscan.vcf.gz

#Create mapfiles
seq 1 22 | xargs -I {} -P 15 plink --keep-allele-order --vcf $VCF.chr{}.selscan.vcf.gz --cm-map MAP/chr{}.b37.gmap {} --recode --out $VCF.chr{}.selscan

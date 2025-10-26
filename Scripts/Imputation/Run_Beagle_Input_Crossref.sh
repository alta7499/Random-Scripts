#!/bin/bash
##Beagle automatically run both phasing and imputation together. accepts vcf input per chr
CHR=$1

bcftools norm -c sw -f ~/Dataset/human.g1k_v37.fasta Input/Input.chr${CHR}.vcf.gz -Oz -o Input/Input.chr${CHR}.normed.vcf.gz --write-index

java -jar -Xmx30g beagle.08Feb22.fa4.jar \
	gt=Input/Input.chr${CHR}.normed.vcf.gz \
	ref=~/REFPANELS/OA_GASP_SG10K.chr${CHR}.bref3 \
	map=MAP/plink.chr${CHR}.GRCh37.map \
	out=Imputed/Input_Crossref/chr${CHR}.imputed \
	ne=20000 \
    nthreads=35

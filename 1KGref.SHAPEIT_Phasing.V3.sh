#!/bin/bash
#Below script is meant to phase chromosome-wise splitted plink binary file with reference panel
#Modify as needed

PLINK=$1
CHR=$2

echo "Plink Binary: $PLINK" > /dev/stderr
echo "CHR: $CHR" > /dev/stderr

REF_DIR=/mnt/storage/subuser1/user2/alvin/Imputation/IMPUTATION_AND_PHASING/TESTRUNIMPUTESCRIPT/REFPANELS
REF_PANEL="$REF_DIR/1000GP_Phase3_chr$CHR.hap.gz $REF_DIR/1000GP_Phase3_chr$CHR.legend.gz $REF_DIR/1000GP_Phase3.sample"
MAP=$REF_DIR/genetic_map_chr$CHR.combined_b37.txt
OUT_DIR=/mnt/storage/subuser1/user2/alvin/Imputation/IMPUTATION_AND_PHASING/TESTRUNIMPUTESCRIPT/NEW_SG_DATA/MAS.45.1KGref

./shapeit -check \
-B $PLINK \
-M $MAP \
--input-ref $REF_PANEL  \
--output-log $OUT_DIR/$PLINK.allignment

if [ -f "$OUT_DIR/$PLINK.allignment.snp.strand.exclude" ]; then
    ./shapeit \
	-B $PLINK \
	-M $MAP \
	--input-ref $REF_PANEL \
	--exclude-snp $OUT_DIR/$PLINK.allignment.snp.strand.exclude \
	-O $OUT_DIR/$PLINK.phased
else
    ./shapeit \
	-B $PLINK \
	-M $MAP \
	--input-ref $REF_PANEL \
	-O $OUT_DIR/$PLINK.phased
fi
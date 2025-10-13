#!/bin/bash

## Require vcftools and plink1.9
## Accept only phased VCF data
## <400,000 markers are enough
## It takes <12h for 400,000 markers
## MAF <5% will be filtered
## Use genetic map: /picb/humpopg/panyuwen/1000GP_Phase3/genetic_map_chr@_combined_b37.txt
## Alvin MOD: change to plink2 for efficiency. takes 5 min for 400k snps. checked that plink2 and vcftools produced exact same R2 value, although for unknown reason compares about 300 less SNPs. but exact value. the script reamins, just change tools and column processing.

input=$1       ## prefix of .vcf.gz file
samplelist=$2  ## samples to keep, sample list file OR "all"
output=$3      ## prefix of output file

## calculate genetic distance
/usr/local/bin/plink --vcf ${input}.vcf.gz --cm-map /home/ucsi01/Alvin/PopGen/Ne_diverge_array/MAP/genetic_map.chr@.combined_b37.txt --double-id --make-bed --out ${output}
samplesize=`cat ${output}.fam | wc -l`

rm ${output}.bed ${output}.fam

## output chromosome IDs
cut -f 1 ${output}.bim | sort | uniq > ${output}.chrom.list
#line2skip=`zcat ${input}.vcf.gz | grep -n "#CHROM" | cut -d ":" -f 1`
#zcat ${input}.vcf.gz | sed "1,${line2skip}d" | awk '{print $1}' | sort | uniq > ${output}.chrom.list

## calculate LD
awk 'BEGIN{OFS="\t";print "CHR\tPOS1\tPOS2\tR^2\tgdis"}' | gzip -c > ${output}.ld.gz

if [ $samplelist = 'all' ]; then
    cat ${output}.chrom.list | while read chr
    do
        plink2 --vcf ${input}.vcf.gz --chr ${chr} --maf 0.05 --r2-phased --ld-window-r2 0 --ld-window-cm 0.25 --out ${output}_chr${chr}
        
        awk 'BEGIN{OFS="\t"}NR==FNR{a[$1":"$4]=$3}NR>FNR && FNR>1{$8=a[$1":"$2];$9=a[$4":"$5];$10=$9-$8;if($10<=0.25 && $10>=0.01)print $1,$2,$5,$7,$10}' ${output}.bim ${output}_chr${chr}.vcor | gzip -c >> ${output}.ld.gz
        rm ${output}_chr${chr}.vcor
    done
else
    cat ${output}.chrom.list | while read chr
    do
        plink2 --vcf ${input}.vcf.gz --chr ${chr} --maf 0.05 --r2-phased --ld-window-r2 0 --ld-window-cm 0.25 --keep $samplelist --out ${output}_chr${chr}
        
        awk 'BEGIN{OFS="\t"}NR==FNR{a[$1":"$4]=$3}NR>FNR && FNR>1{$8=a[$1":"$2];$9=a[$4":"$5];$10=$9-$8;if($10<=0.25 && $10>=0.01)print $1,$2,$5,$7,$10}' ${output}.bim ${output}_chr${chr}.vcor | gzip -c >> ${output}.ld.gz
        rm ${output}_chr${chr}.vcor
    done
    samplesize=`cat $samplelist | wc -l`
fi

rm ${output}.bim
#rm ${output}_chr*.log

## Ne
python Ne.py ${output}.ld.gz $samplesize

## Done
echo "output saved in ${output}.ld.gz ${output}_Ne.txt"

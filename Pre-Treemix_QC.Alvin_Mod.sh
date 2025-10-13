#Make sure that the population was merged in plink binary format and Kinship analysis have been performed before proceeding with this code. Note that plink, plink2, bcftools must be installed
#The .clust file contains three columns: samplename\tsamplename\tgroup
#use plink as input
#Merged population binary file = BIN
file=$1
clust=$2

#QC 
plink2 \
    --bfile $file \
    --snps-only \
    --geno 0 \
    --hwe 0.00001 \
	--maf 0.01 \
    --make-bed --out $file.QCed

# convert it to a stratified frq file, also creates .bed, .bim, .fam, .log, .nosex
#plink --file $file --make-bed --out $file --allow-no-sex --allow-extra-chr 
./plink --bfile $file.QCed --keep-allele-order --freq --missing --within $clust --recode --out $file.stats --threads 10

# zip it
gzip $file.stats".frq.strat" 

# create input file for Treemix
./plink2treemix.py $file.stats".frq.strat.gz" $file".treemix.frq.gz"

# unzip allele frequency information
gunzip $file".treemix.frq.gz"
gunzip $file.stats".frq.strat.gz"

# make a file with the positions
awk 'BEGIN{print "scaffold_pos\tscaffold\tpos"}{split($2,pos,":");print $2"\t"pos[1]"\t"pos[2]}' $file.stats".map" > $file".positions"
paste $file".positions" $file".treemix.frq" > $file".frequencies"

awk '{printf $0
	for(i = 4; i <= NF; i++){
		split($i,values,",")
		if((values[1]+values[2])>0) freq=values[1]/(values[1]+values[2])
		else freq=0
		printf freq"\t"
	}
	printf "\n"}'  $file".frequencies" > $file".frequencies2"
mv $file".frequencies2" $file".frequencies"

awk 'BEGIN{scaffold="";pos=0;newpos=0}
	{if($2==scaffold){newpos=pos+$3}else{scaffold=$2;pos=newpos};chpos=pos+$3;print $0,chpos}' \
	$file".frequencies" > $file".frequencies.newpos"

gzip $file".treemix.frq"

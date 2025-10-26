#! /usr/bin/perl -w
use strict;

my ($input1, $input2) = @ARGV; ## *.ped 

my %snp;
open F1, "$input1.map";
while (<F1>) {
	chomp;
	my @line = split /\s+/;
	$snp{"$line[0] $line[3]"} ++; ## select SNPs according to position
}
close F1;
open F1, "$input2.map";
while (<F1>) {
	chomp;
	my @line = split /\s+/;
	$snp{"$line[0] $line[3]"} ++; ## select SNPs according to position
}
close F1;

my @include1;
my $i = 0;
open F1, "$input1.map";
open OUT, ">newfile.map";
while (<F1>) {
	chomp;
	my @line = split /\s+/;
	$i ++;
	if ($snp{"$line[0] $line[3]"} == 2) {
		push @include1, $i;
		print OUT join "\t", @line;
		print OUT "\n";
	}
}
close F1;
close OUT;

my @include2;
$i = 0;
open F1, "$input2.map";
while (<F1>) {
        chomp;
        my @line = split /\s+/;
        $i ++;
        if ($snp{"$line[0] $line[3]"} == 2) {
                push @include2, $i;
        }
}
close F1;

my $n = @include1;

open OUT, ">newfile.ped";

open F1, "$input1.ped";
while (<F1>) {
	chomp;
	my @line = split /\s+/;
	my @newline;
	foreach my $j (@include1) { ## 6 columns before genotype column
		push @newline, "$line[2*$j+4] $line[2*$j+5]"; 
	}
	my $nn = @newline;
	if ($nn != $n) {print "$line[0] $line[1] $nn $n\n";}
	print OUT join " ", @line[0 .. 5],@newline;
	print OUT "\n";
}
open F1, "$input2.ped";
while (<F1>) {
        chomp;
        my @line = split /\s+/;
        my @newline;
        foreach my $j (@include2) { ## 6 columns before genotype column
                push @newline, "$line[2*$j+4] $line[2*$j+5]";
        }
        my $nn = @newline;
        if ($nn != $n) {print "$line[0] $line[1] $nn $n\n";}
        print OUT join " ", @line[0 .. 5],@newline;
        print OUT "\n";
}

close OUT;




my %allele;
for (my $j=1;$j<=$n;$j++) {
	@{$allele{$j}} = (0,0,0,0); ## ATCG
}

open F1, "newfile.ped";
while(<F1>){
	chomp;
	my @line = split;
	for (my $j=1;$j<=$n;$j++) {
		if ($line[2*$j+4] !~ /0/) {
			if ($line[2*$j+4] eq "A") {@{$allele{$j}}[0] = "A";}
			elsif ($line[2*$j+4] eq "T") {@{$allele{$j}}[1] = "T";}
			elsif ($line[2*$j+4] eq "C") {@{$allele{$j}}[2] = "C";}
			elsif ($line[2*$j+4] eq "G") {@{$allele{$j}}[3] = "G";}
			if ($line[2*$j+5] eq "A") {@{$allele{$j}}[0] = "A";}
			elsif ($line[2*$j+5] eq "T") {@{$allele{$j}}[1] = "T";}
			elsif ($line[2*$j+5] eq "C") {@{$allele{$j}}[2] = "C";}
			elsif ($line[2*$j+5] eq "G") {@{$allele{$j}}[3] = "G";}
		}
	}
}
close F1;

my @new_n;
open F1, "newfile.map";
open OUT, ">newfile.checked.map";
my $j = 0;
while (<F1>) {
	$j ++;
	my $line = $_;
        my %count;
	foreach (@{$allele{$j}}) {
		$count{$_} ++;
	}
	if (exists $count{"0"} and $count{"0"} >= 2) {
		push @new_n, $j;
		print OUT join "\t", $line;
	}
}
close F1;
close OUT;

open F1, "newfile.ped";
open OUT, ">newfile.checked.ped";
while(<F1>){
        chomp;
        my @line = split;
	my @new_line = @line[0 .. 5];
        foreach my $j (@new_n) {
        	push @new_line, $line[2*$j+4];
		push @new_line, $line[2*$j+5];
	}
	print OUT join " ",@new_line;
	print OUT "\n";
}
close F1;
close OUT;


#! /usr/bin/perl -w
use strict;
#use Statistics::Descriptive;

my $indir = shift;
my $r = shift;

chdir "$indir" or die "cannot change the directory:$!";
my @files=glob "*sort.fst";

foreach my $file (@files) {
	print "Dealing with $file...\n";
	open F1,"$file" or die "cannot open the file:$!";
	my ($a,$b)=(0,0);
	my %ab;
 	my $k=0;
	while (<F1>) {
		chomp;
 		$k++;
		my @line=split/\t/;
		$a += $line[4];
		$b += $line[5];
 		push @{$ab{$k}},$line[4];
 		push @{$ab{$k}},$line[5];
	}
	close F1;
	my $fst=$a/$b;
	
	## Bootstrapping for IC
	my @fst;
  	for (my $i=1;$i<=$r;$i++) {
  		print "$i\n" if ($i % 100 == 0);
		open OUT,">>","$file.Global.fst.$r.txt" or die "cannot open the file:$!";		
		my (@index_new,@a_new,@b_new);
		my @index = keys %ab;
		push @index_new,$index[rand @index] for (1 .. $k);
#		push @index_new,splice(@index,rand @index,1) for (1 .. $k);
		foreach (@index_new) {
			push @a_new, @{$ab{$_}}[0];
			push @b_new, @{$ab{$_}}[1];
		}
		my ($a_new,$b_new)=(0,0);
		foreach (@a_new) {
			$a_new+=$_;
		}
		foreach (@b_new) {
			$b_new+=$_;
		}
		my $fst_new=$a_new/$b_new;
	  	print OUT "$fst_new\n";
		close OUT;
  	}
# 	my $stat = Statistics::Descriptive::Full->new();
# 	$stat->add_data(@fst);
# 	my $mean = $stat->mean();
# 	my $variance = $stat->variance();
# 	my $num = $stat->count();
# 	my $CI1=$mean-$variance/sqrt($num)*1.96;
# 	my $CI2=$mean+$variance/sqrt($num)*1.96;
# 	my $sd=sqrt($variance);
#   	print OUT "$file\t$fst\n";
#   	print OUT "$file\t$mean\t$CI1\t$CI2\t$sd\n";
}
# close OUT;


#!/usr/bin/env perl
# copyright (c) 2017 Mitsuhiko Sato. All Rights Reserved.
# Mitsuhiko Sato ( E-mail: mitsuhikoevolution@gmail.com )
use strict;
use warnings;
use FindBin;
die "USAGE: correlation_matrix_srst2.pl srst2__gene__*__results.txt output_prefix [0|1|2] \n 
argment3 undetected mark; 0:only - (default). 1:- and ? . 2:- , ? and * \n" unless(@ARGV == 2 or @ARGV == 3);


open(IN,$ARGV[0]) or die "$!";
open(OUT, ">$ARGV[1].txt");
my $THRES = 0;
if(defined($ARGV[2])){
    $THRES=$ARGV[2];
}
die "arg3: 0 or 1 or 2" unless($THRES == 0 or $THRES == 1 or $THRES == 2);

my $label=<IN>;
chomp($label);
my @labels=split(/\t/,$label);
shift(@labels);
print OUT "\t";
print OUT join("\t", @labels),"\n";

my @srst;
my @temp=();
my $nlbl = @labels;

my @lines;
my $nstr=0;
while(my $line = <IN>){
    chomp($line);
    @lines=split(/\t/,$line);
    shift(@lines);

    for(my $i = 0; $i < @lines; $i++){
        if($THRES == 0){
            if($lines[$i] eq "-" ){
                $srst[$nstr][$i]=0;
            }else{
                $srst[$nstr][$i]=1;         
            }
        }elsif($THRES == 1){
            if($lines[$i] eq "-" or $lines[$i] =~ /\?$/){
                $srst[$nstr][$i]=0;
            }else{
                $srst[$nstr][$i]=1;
            }
        }elsif($THRES == 2){
            if($lines[$i] eq "-" or $lines[$i] =~ /\?$/ or $lines[$i] =~ /\*$/){
                $srst[$nstr][$i]=0;
            }else{
                $srst[$nstr][$i]=1;
            }
        }
    }
    $nstr++;
}
close(IN);

my (@x, @y);
my $corr;
my $ERR=0;

for(my $i = 0; $i < $nlbl; $i++ ){
    print OUT "$labels[$i]\t";

    @x=();
    foreach my $t(@srst){
	push(@x, @{$t}[$i]);
    }
    $ERR = check_sd(@x);
    for(my $j = 0; $j < $nlbl; $j++){
	if($ERR == 0 ){	    
	    @y=();
	    foreach my $t(@srst){
		push(@y, @{$t}[$j]);
	    }
	    $ERR = check_sd(@y);
	}
	if($ERR == 0){
	    $corr=correlation(@x, @y);
	}else{
	    $corr="-999";
	}
	print OUT "$corr\t";
    }
    print OUT "\n";
}
close(OUT);

system("R --vanilla --slave --args $ARGV[1] < $FindBin::Bin\/correlation_matrix_srst2.r");


sub check_sd{
    my @n = @_;
    my $n = @_;
    my $mean = 0;
    my $square_sum = 0;
    foreach my $i (@n){
	$mean+=$i;
    }
    $mean=$mean/$n;
    foreach my $i (@n){
	$square_sum+=($i-$mean);
    }
    return(1) if($square_sum == 0);
    return(0);
}


sub correlation{
    my $n=@_;
    my $m=$n/2;
    my (@x,@y);
    for(my $i=0;$i<$m;$i++){
        $x[$i]=shift(@_);
    }
    for(my $i=0;$i<$m;$i++){
        $y[$i]=shift(@_);
    }

    my $x_sd=&sd(@x);
    my $y_sd=&sd(@y);
    my $cov=&covariance(@x,@y);
    my $cor=$cov/($x_sd*$y_sd);
    return($cor);
}
sub correlation2{
    my $n=@_;
    my $m=$n/2;
    my (@x,@y);
    for(my $i=0;$i<$m;$i++){
        $x[$i]=shift(@_);
    }
    for(my $i=0;$i<$m;$i++){
        $y[$i]=shift(@_);
    }
     
    my $x_sd=&sd(@x);
    my $y_sd=&sd(@y);
    my $cov=&covariance(@x,@y);
    my $cor=$cov/($x_sd*$y_sd);
    return($cor*$cor);
}

sub sd{
    my $n=@_;
    my $mean=0;
    foreach my $i (@_){
        $mean+=$i/$n;
    }
    my $square_sum=0;
    foreach my $i (@_){
        $square_sum+=($i-$mean)**2;
    }
     
    my $sd=($square_sum/$n)**(1/2);     
    return($sd);
}

sub covariance{
    my $n=@_;
    my $m=$n/2;
    my (@x,@y);
    for(my $i=0;$i<$m;$i++){
        $x[$i]=shift(@_);
    }
    for(my $i=0;$i<$m;$i++){
        $y[$i]=shift(@_);
    }
     
    my $x_mean=0;
    foreach my $i (@x){
        $x_mean+=$i/$m;
    }
    my $y_mean=0;
    foreach my $i (@y){
        $y_mean+=$i/$m;
    }
    my $cov=0;
    for(my $i=0;defined($x[$i]);$i++){
        $cov+=(($x[$i]-$x_mean)*($y[$i]-$y_mean))/$m;
    }
     
    return($cov);
}

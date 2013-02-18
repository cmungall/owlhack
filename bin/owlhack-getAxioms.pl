#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

my @axs = $ont->getAxioms(@ARGV);

foreach my $ax (@axs) {
    printf "$ax\n";
}







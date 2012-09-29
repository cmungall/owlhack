#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

my @axs = $ont->getAxioms('SubClassOf');

foreach my $ax (@axs) {
    printf "%s\t%s\n", $ax->getSubClass(), $ax->getSuperClass();
}







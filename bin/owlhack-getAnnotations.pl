#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

my @axs = $ont->getAxioms('AnnotationAssertion');

foreach my $ax (@axs) {
    printf "%s\t%s\t%s\n", $ax->getSubject(), $ax->getProperty(), $ax->getValue();
}







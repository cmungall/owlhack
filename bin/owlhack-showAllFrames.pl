#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

my @objs = $ont->getDeclared();
foreach my $e (@objs) {
    my $fr = $ont->getFrame($e);
    print "$fr\n";
}







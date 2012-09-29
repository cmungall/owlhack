#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

foreach my $e ($ont->getDeclared()) {
    printf "%s\t%s\n", $e, join(', ',$ont->getLabels($e));
}







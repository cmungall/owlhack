#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);

my @objs = $ont->getDeclared();
#printf STDERR "Objs: %d\n", scalar(@objs);
foreach my $e (@objs) {
    printf "%s\t%s\n", $e, join(', ',$ont->getLabels($e));
}







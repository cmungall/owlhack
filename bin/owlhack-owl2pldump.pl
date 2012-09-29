#!/usr/bin/perl

use OWL;
use Data::Dumper;

my $ont = OWL->loadFromJS(shift @ARGV);

print Dumper $ont;






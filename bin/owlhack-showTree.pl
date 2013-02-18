#!/usr/bin/perl

use OWL;
use OWL::Util;
use Data::Dumper;
use OWL::Change::AddAxiom;

my $ont = OWL->load(shift @ARGV);
OWL::Util->new()->showTree($ont);







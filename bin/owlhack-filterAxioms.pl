#!/usr/bin/perl

use OWL;
use Data::Dumper;
use OWL::Renderer::JSONRenderer;
use OWL::Change::RemoveAxiom;

my $ont = OWL->load(shift @ARGV);

my @axs = $ont->getAxioms(@ARGV);
my $r = OWL::Renderer::JSONRenderer->new();

foreach my $ax (@axs) {
    my $rm = new OWL::Change::RemoveAxiom($ax);
    printf "%s\n", $r->render($rm);
}







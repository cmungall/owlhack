#!/usr/bin/perl

use OWL;
use Data::Dumper;
use OWL::Renderer::JSONRenderer;
use OWL::Change::RemoveAxiom;

my $f = shift @ARGV;
if (!$f) {
    print usage();
    exit 1;
}

my $ont = OWL->load($f);

my @axs = $ont->getAxioms(@ARGV);
my $r = OWL::Renderer::JSONRenderer->new();

foreach my $ax (@axs) {
    my $rm = new OWL::Change::RemoveAxiom($ax);
    printf "%s\n", $r->render($rm);
}

exit 0;

## USAGE

sub scriptname {
    my @p = split(/\//,$0);
    pop @p;
}
sub usage {
    my $sn = scriptname();

    <<EOM;
$sn ONTOLOGY

Generate a set of remove axiom actions. This can then be further processed before using owltools --apply-patch

EOM
}


















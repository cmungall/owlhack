#!/usr/bin/perl

use OWL::Renderer::FunctionalRenderer;
use OWL;
use Data::Dumper;

my $inFile = shift @ARGV;
my $ont = OWL->load($inFile);
my $tr = shift;

my @axs = $ont->getAxioms('AnnotationAssertion');

my $sub = eval("sub { \$_ = shift; $tr; return \$_ }");

my @rmAxioms = ();
my @addAxioms = ();
foreach my $ax (@axs) {
    my $v = $ax->getValue;
    my $v2 = $sub->($v);
    if ($v ne $v2) {
        #print "-$ax\n";
        push(@rmAxioms, $ax);
        $ax2 = OWL->createAxiom('AnnotationAssertion',$ax->getProperty,$ax->getSubject,$v2);
       # print "+$ax2\n";
        push(@addAxioms, $ax2);
    }
}

mkOntoDelta($inFile, "$inFile.NEW", \@rmAxioms, \@addAxioms);

sub mkOntoDelta {

    my $in = shift;
    my $out = shift;

    my $rmOntFn = "$in.minusAxioms";
    my $addOntFn = "$in.plusAxioms";

    my @rmAxioms = @{shift || []};
    my @addAxioms = @{shift || []};
    printf STDERR "Num: %d\n", scalar(@rmAxioms);
    
    my $r = OWL::Renderer::FunctionalRenderer->new();
    my $rmOnt = OWL::Ontology->new({axioms=>[@rmAxioms]});
    
    $r->save($rmOnt,$rmOntFn);

    my $addOnt = OWL::Ontology->new({axioms=>[@addAxioms]});
    $r->save($addOnt,$addOntFn);

    my $cmd = "owltools $in --apply-patch $rmOntFn $addOntFn -o file://`pwd`/$out";
    if (system($cmd)) {
        die "$cmd";
    }

}







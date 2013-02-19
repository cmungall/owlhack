#!/usr/bin/perl

use OWL::Renderer::FunctionalRenderer;
use OWL;
use Data::Dumper;

while ($ARGV[0] =~ /^(\-.*)/) {
    my $opt = shift;
    if ($opt eq '-h' || $opt eq '--help') {
        print usage();
        exit 0;
    }
    else {
        die $opt;
    }
}

my $tr = shift @ARGV;
my $inFile = shift @ARGV;
my $ont = OWL->load($inFile);

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

exit 0;

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

## USAGE

sub scriptname {
    my @p = split(/\//,$0);
    pop @p;
}


sub usage {
    my $sn = scriptname();

    <<EOM;
$sn EXPR ONTOLOGY

Performs a perl operation on the values of all annotation assertion
axioms, then writes out a new ontology (same name as original with .NEW suffix)

Example:

$sn "s/Hand/Manus/" anatomy.owl

EOM
}












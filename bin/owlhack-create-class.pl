#!/usr/bin/perl

use OWL::Renderer::FunctionalRenderer;
use OWL;
use Data::Dumper;

my %ch = ();
my @anns = ();
my $iri;

while ($ARGV[0] =~ /^(\-.*)/) {
    my $opt = shift;
    if ($opt eq '-i' || $opt eq '--iri') {
        $iri = shift @ARGV;
    }
    elsif ($opt eq '-l' || $opt eq '--label') {
        push(@anns, {RDFS::Vocabulary::Label()=>shift @ARGV});
    }
    elsif ($opt eq '-a' || $opt eq '--annotation') {
        push(@anns, {shift @ARGV=>shift @ARGV});
    }
    elsif ($opt eq '-h' || $opt eq '--help') {
        print usage();
        exit 0;
    }
    else {
        die $opt;
    }
}

my $inFile = shift @ARGV;
my $ont = OWL->load($inFile);

die "INCOMPLETE";

exit 0;


## USAGE

sub scriptname {
    my @p = split(/\//,$0);
    pop @p;
}


sub usage {
    my $sn = scriptname();

    <<EOM;

$sn [-i IRI] [-l LABEL] [-a ANN]* ONT

NOT IMPLEMENTED     

EOM
}






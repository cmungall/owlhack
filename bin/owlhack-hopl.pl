#!/usr/bin/perl

use OWL;
use OWL::HOPL;
use Data::Dumper;
use OWL::Renderer::FunctionalRenderer;
my $expr;
my @onts = ();
my $outf;

while ($ARGV[0] =~ /^\-/) {
    my $opt = shift @ARGV;
    if ($opt eq '-e' || $opt eq '--expression') {
        $expr = eval shift;
    }
    elsif ($opt eq '-f' || $opt eq '--file') {
        open(F,shift @ARGV) || die;
        my $exprStr = join('',<F>);
        $expr = eval "sub { $exprStr }";
        close(F);
    }
    elsif ($opt eq '-o' || $opt eq '--out') {
        $outf = shift @ARGV;
    }
    else {
        die $opt;
    }
}

my $ont = OWL->load(shift @ARGV);
my $hopl = OWL::HOPL->new();
my $ch = $hopl->process($expr,$ont);
print STDERR "CHANGES: $ch\n";

my $r = OWL::Renderer::FunctionalRenderer->new();

if ($outf) {
    die;
}
else {
    print $r->render($ont);
}







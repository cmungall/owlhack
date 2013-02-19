#!/usr/bin/perl

use OWL;
use OWL::Renderer::MarkdownRenderer;
use Data::Dumper;

my $ont = OWL->load(shift @ARGV);
my $r = OWL::Renderer::MarkdownRenderer->new();

print $r->render($ont);







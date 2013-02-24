package OWL::Change::AddAxiom;
use base OWL::Change;
sub getType {'AddAxiom'}

sub apply {
    my $self = shift;
    my $ont = shift;
    $ont->addAxiom($self->{axiom});
}

1;


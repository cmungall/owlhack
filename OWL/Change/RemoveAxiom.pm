package OWL::Change::RemoveAxiom;
use base OWL::Change;
sub getType {'RemoveAxiom'}

sub apply {
    my $self = shift;
    my $ont = shift;
    $ont->removeAxiom($self->{axiom});
}

1;


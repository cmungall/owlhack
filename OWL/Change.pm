package OWL::Change;

# Abstract

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    $this->{axiom} = shift;
    return $this;
}

sub getAxiom {
    return shift->{axiom};
}

use overload '""' => sub {shift->to_string()};

sub to_string {
    my $self = shift;
    return $self->getType . ' ' . $self->{axiom};
}

1;

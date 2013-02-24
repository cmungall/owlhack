package OWL::HOPL;

use OWL::Change::AddAxiom;
use OWL::Change::RemoveAxiom;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    $this->{ont} = shift;
    return $this;
}

sub process {
    my $self = shift;
    my $expr = shift;
    my $ont = shift;
    
    my @changes = $self->getChanges($expr, $ont);
    if (!$ont) {
        $ont = $self->{ont};
    }
    foreach (@changes) {
        $_->apply($ont);
    }
    return scalar(@changes);
}

sub getChanges {
    my $self = shift;
    my $expr = shift;
    my $ont = shift;
    if (!$ont) {
        $ont = $self->{ont};
    }
    my @change = map { $self->getChange($_, $expr->($_,$ont)) } $ont->getAxioms();
    return @change;
}

sub getChange {
    my $self = shift;
    my $original_axiom = shift;
    my $change = shift;
    if (!$change) {
        return ();
    }
    if (ref($change)) {
        if ($change->isa('OWL::Change')) {
            return $change;
        }
        return (OWL::Change::AddAxiom->new($change),
                OWL::Change::RemoveAxiom->new($original_axiom));
    }
    else {
        my $new_axiom = shift;
        if ($change eq 'replace') {
            return (OWL::Change::AddAxiom->new($new_axiom),
                    OWL::Change::RemoveAxiom->new($original_axiom));
        }
        elsif ($change eq 'add') {
            return (OWL::Change::AddAxiom->new($new_axiom));
        }
        elsif ($change eq 'remove') {
            return (OWL::Change::RemoveAxiom->new($original_axiom));
        }
        else {
            die $change;
        }
    }
}

1;

package OWL::Ontology;
use strict;
use vars qw(@ISA $AUTOLOAD);
use OWL::OWLObject;
use OWL::Frame;
use OWL::RDFSVocabulary;
use Carp;

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless shift, $class;
    $this->init();
    return $this;
}

sub init {
    
}

sub h2obj {
    my $h = shift;
    if (!ref($h)) {
        return $h;
    }
    elsif (ref($h) && ref($h) eq 'HASH') {
        my $obj = [map {h2obj($_)} @{$h->{args}}];
        bless $obj, $h->{type};
        return $obj;
    }
    elsif (ref($h) && ref($h) eq 'ARRAY') {
        # EXPERIMENTAL: literals
        bless $h, 'Literal';
        return $h;
    }
    else {
        # already an owl object
        return $h;
    }

}

sub getLabels {
    my ($self,$subj) = @_;
    return shift->getAnnotationValues($subj, OWL::RDFSVocabulary->label);
}

# TODO: index
sub getObjectsByAnnotationValue {
    my $self = shift;
    my $prop = shift;
    my $val = shift;
    my @axs = $self->getAnnotationAssertionAxioms();
    my @objs = ();
    foreach my $ax (@axs) {
        if ($ax->getProperty() eq $prop && $ax->getValue eq $val) {
            push(@objs, $ax->getSubject);
        }
    }
    return @objs;
}

sub getAnnotationValues {
    my $self = shift;
    my $subj = shift;
    my $prop = shift;
    my @vals = ();
    my @axs = $self->getAnnotationAssertionAxioms($subj);
    foreach my $ax (@axs) {
        if ($ax->getProperty() eq $prop) {
            push(@vals, $ax->getValue);
        }
    }
    return @vals;
}

sub getAxiomCount {
    my $self = shift;
    return scalar($self->getAxioms);
}

sub getAxioms {
    my $self = shift;
    my ($t, $subj) = @_;
    if ($subj) {
        my $frame = $self->getFrame($subj);
        if ($frame) {
            return $frame->getAxioms($t);
        }
        else {
            return ();
        }
    }
    return map {h2obj($_)} $self->_getAxioms(@_);
}

sub _getAxioms {
    my $self = shift;
    my ($t) = @_;
    if ($t) {
        if (!ref($_) eq 'HASH') {
            confess $_;
        }
        return grep {$_->{type} eq $t} @{$self->{axioms} || []};
    }
    else {
        return @{$self->{axioms} || []};
    }
}

sub removeAxiom {
    my $self = shift;
    my $axiom = shift;
    my $axiomStr = "$axiom";
    my @axioms = $self->getAxioms();
    my @new = grep {"$_" ne $axiomStr} @axioms;
    if (@new == @axioms) {
        die "could not find $axiom";
    }
    $self->{axioms} = \@new;
    return $axiom;
}

sub addAxiom {
    my $self = shift;
    my $axiom = shift;
    push(@{$self->{axioms}}, $axiom);
    return $axiom;
}

sub getDeclared {
    my $self = shift;
    return map {$_->{args}->[1]} $self->_getAxioms('Declaration');
}

# TODO: use frames
sub getAnnotationAssertionAxioms {
    my ($self,$subj) = @_;
    my @axs = $self->getAxioms('AnnotationAssertion', $subj);
    return @axs;
}

sub getClassAssertionAxioms {
    my ($self,$subj) = @_;
    my @axs = $self->getAxioms('ClassAssertion', $subj);
    return @axs;
}

sub getIRI {
    my $self = shift;
    return $self->{iri};
}

sub _collectFrames {
    my $self = shift;
    if (@{$self->{frames} || []}) {
        return $self->{frames};
    }
    my %axiom_map = ();
    foreach ($self->getAxioms) {
        foreach my $obj ($_->getObjectsInSignature) {
            if ($_->isAbout($obj)) {
                push(@{$axiom_map{$obj}}, $_);
            }
        }
    }
    
    $self->{frame_ix} = {};
    #my @objs = $self->getDeclared;
    my @objs = keys %axiom_map;
    foreach (@objs) {
        $self->{frame_ix}->{$_} = OWL::Frame->new($axiom_map{$_});
    }
    $self->{frames} = [values %{$self->{frame_ix}}];
    return @{$self->{frames}};
}

sub getFrame {
    my ($self,$obj) = @_;
    $self->_collectFrames();
    my $frame = $self->{frame_ix}->{$obj};
    if (!defined $frame) {
        return undef;
        #confess("no frame: $obj\n");
    }
    return $frame;
}

1;

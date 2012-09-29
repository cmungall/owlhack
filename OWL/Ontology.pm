package OWL::Ontology;
use strict;
use vars qw(@ISA $AUTOLOAD);
use OWL::OWLObject;
use OWL::RDFSVocabulary;

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
    if (ref($h) && ref($h) eq 'HASH') {
        my $obj = [map {h2obj($_)} @{$h->{args}}];
        bless $obj, $h->{type};
        return $obj;
    }
    die $h;
}

sub getLabels {
    my ($self,$subj) = @_;
    return shift->getAnnotationValues($subj, OWL::RDFSVocabulary->label);
}


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

sub getAxioms {
    return map {h2obj($_)} shift->_getAxioms(@_);
}

sub _getAxioms {
    my $self = shift;
    my $t = shift;
    if ($t) {
        return grep {$_->{type} eq $t} @{$self->{axioms} || []};
    }
    else {
        return @{$self->{axioms} || []};
    }
}

sub getDeclared {
    my $self = shift;
    return map {$_->{args}->[0]} $self->_getAxioms('Declaration');
}

# TODO: use frames
sub getAnnotationAssertionAxioms {
    my ($self,$subj) = @_;
    my @axs = $self->getAxioms('AnnotationAssertion');
    if ($subj) {
        @axs = grep {$_->getSubject eq $subj} @axs;
    }
    return @axs;
}
sub old___getAnnotationAssertionAxioms {
    my ($self,$subj) = @_;
    my @axs = $self->getAxioms('AnnotationAssertion');
    if ($subj) {
        @axs = grep {$_->getSubject eq $subj} @axs;
    }
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
    my @objs = $self->getDeclared;
    my @frames =
        map {$self->_collectFrame($_)} @objs;
    $self->{frames} = \@frames;
    return @frames;
}

sub _collectFrame {
    my $self = shift;
    my ($obj) = @_;
    my @axs = grep { $_->isAbout($obj) } ($ont->getAxioms);
    my $frame = OWL::Frame->new(\@axs);
    return $frame;
}


1;
package OWLGeneric;
#sub getProperty {shift->[0]};
our %META =
    (
     'AnnotationAssertion' => [qw(Property Subject Value)],
    );

my %ARGMAP = ();

sub initARGMAP {
    print STDERR "INIT...\n";
    foreach my $type (keys %META) {
        #print STDERR "T $type\n";
        my $i = 0;
        my @fields = @{$META{$type}};
        foreach (@fields) {
            print STDERR " F: $_\n";
            $ARGMAP{$type}->{$_} = $i;
            $i++;
        }
    }
}

sub AUTOLOAD {
    
    my $self = shift;

    if (!%ARGMAP) {
        initARGMAP();
    }

    my $name = $AUTOLOAD;
    $name =~ s/.*://;   # strip fully-qualified portion

    if ($name eq "DESTROY") {
	# we dont want to propagate this!!
	return;
    }

    confess("$self") unless ref($self);
    
    if ($name =~ /get(.+)/) {
        my $ix = $ARGMAP{ref($self)}->{$1};
        return $self->[$ix];
    }

    die("can't do $name on $self");
    
}


1;

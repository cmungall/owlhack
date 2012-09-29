package OWL::Frame;
use strict;
use vars qw(@ISA $AUTOLOAD);
use OWL::OWLObject;
use OWL::RDFSVocabulary;

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    $this->init(@_);
    return $this;
}

sub init {
    my $self = shift;
    $self->{axioms} = shift;
}

sub createFrame {
    my $proto = shift;
    my ($obj,$ont) = @_;
    my $self = bless {}, ref($proto);
    my @axs = grep { $_->isAbout($obj) } ($ont->getAxioms);
    $self->{axioms} = \@axs;
    return $self;
}

sub getAxioms {
    return $self->{axioms};
}

package OWL::Frame;
use strict;
use vars qw(@ISA $AUTOLOAD);
use OWL::OWLObject;
use OWL::RDFSVocabulary;

use overload '""' => sub {shift->to_string()};

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
    my $axs = shift;
    $self->{axioms} = $axs;
}


sub getAxioms {
    my $self = shift;
    my ($t) = @_;
    if ($t) {
        # TODO
        return grep {ref($_) eq $t} @{$self->{axioms} || []};
    }
    else {
        return @{$self->{axioms}};
    }
}

sub to_string {
    my $self = shift;
    return ref($self) . 
        "[\n  " . join("\n  ",map {$_} $self->getAxioms) . "\n]";
}

1;

package OWL::OWLFrame;
use OWL::OWLObject;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    $this->collect(@_);
    return $this;
}

sub collect {
    my ($self,$obj,$ont) = @_;
    
    
}



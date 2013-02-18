package OWL::Util;
use OWL::OWLObject;
use strict;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    return $this;
}


sub getRoots {
    my $self = shift;
    my $ont = shift;
    my @scas = $ont->getAxioms('SubClassOf');
    $self->{subClassMap} = {};
    foreach (@scas) {
        push(@{$self->{subClassMap}->{$_->getSuperClass}}, $_->getSubClass);
    }
    my %nonrooth = map {($_->getSubClass=>1)} @scas;
    return grep {!$nonrooth{$_}} $ont->getDeclared();
}

sub showTree {
    my $self = shift;
    my $ont = shift;
    my @roots = $self->getRoots($ont);
    foreach (@roots) {
        $self->showTreeFrom($ont,$_,1);
    }
}

sub showTreeFrom {
    my $self = shift;
    my ($ont, $obj, $depth) = @_;
    print ' ' x $depth;
    print $obj;
    print " ";
    print $ont->getLabels($obj);
    print "\n";
    #foreach ($ont->getFrame($obj)->getSubClasses($ont)) {
    foreach ($self->getSubClasses($obj)) {
        $self->showTreeFrom($ont, $_, $depth+1);
    }
}

sub getSubClasses {
    my $self = shift;
    my $obj = shift;
    return @{$self->{subClassMap}->{$obj} || []};
}

1;

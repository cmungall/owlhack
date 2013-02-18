package OWL::Frame::ClassFrame;
use base OWL::Frame;
use strict;

sub getSuperClasses {
    my $self = shift;
    return map {$_->getSuperClass} $self->getAxioms('SubClassOf');
}

1;

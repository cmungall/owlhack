package OWL::Renderer::JSONRenderer;
use base OWL::Renderer;
use JSON;
use strict;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    return $this;
}

sub render {
    my $self = shift;
    return JSON->new->encode($self->toHash(@_));
}

sub toHash {
    my $self = shift;
    my $obj = shift;
    if (ref($obj)) {
        if ($obj->isa("OWL::Ontology")) {
            return {
                
                axioms=>[map{$self->toHash($_)} $obj->getAxioms]
            };
        }
        elsif ($obj->isa("OWL::Change")) {
            return {
                type=>$obj->getType,
                axiom=>$self->toHash($obj->getAxiom)
            }
        }
        else {
            # TODO: annotations
            return {type=>ref($obj),
                    args=>[map {$self->toHash($_)} @$obj]};
        }
    }
    else {
        return $obj;
    }
}
1;

package OWL::Renderer::FunctionalRenderer;
use base OWL::Renderer;
use JSON;
use strict;

# TODO: escaping etc

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    return $this;
}

sub render {
    my $self = shift;
    my $obj = shift;
    if ($obj->isa("OWL::Ontology")) {
        $self->renderOntology($obj);
    }
    else {
        return $obj->to_string;
    }
}

sub renderOntology {
    my $self = shift;
    my $ont = shift;
    my $s = "";
    $s .= "Prefix(owl:=<http://www.w3.org/2002/07/owl#>)\n";
    $s .= "Prefix(xsd:=<http://www.w3.org/2001/XMLSchema#>)\n";
    $s .= "\n";
    $s .= "Ontology(";
    if ($ont->getIRI) {
        $s .= "<".$ont->getIRI().">";
    }
    $s.= "\n";
    # TODO: imports, anns
    foreach my $ax ($ont->getAxioms) {
        $s.= $self->render($ax)."\n";
    }
    $s.=")\n";
    return $s;
}
1;

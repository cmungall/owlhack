my ($axiom,$ont) = @_;
if ($axiom->isa('SubClassOf') && $axiom->getSuperClass()->isa("ObjectSomeValuesFrom")) {
    my $new_axiom = OWL->createAxiom('SubClassOf',$axiom->getSuperClass()->getFiller, $axiom->getSubClass);
    return $new_axiom;
}
return;



use OWL::FunctionalWriter;

sub render {
    my $self = shift;
    my $obj = shift;
    if (isIRI($obj)) {
        $self->w("<" . $obj . ">");
    }
    elsif ($self->isa("OWL::Ontology")) {
        
    }
    elsif ($self->isa("OWL::OWLObject")) {
        my $t = ref($obj);
        $self->w($t);
        $self->('(');
        my $i=0;
        foreach (@$obj) {
            if ($i) {
                $self->w(' ');
            }
            $self->render($_);
            $i++;
        } 
        $self->(')');
        if ($self->isa("OWL::Axiom")) {
            $self->w("\n");
        }
    }
}

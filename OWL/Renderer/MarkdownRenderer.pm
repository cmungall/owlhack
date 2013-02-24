package OWL::Renderer::MarkdownRenderer;
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
    my $obj = shift;
    if ($obj->isa("OWL::Ontology")) {
        return $self->renderOntology($obj);
    }
    if ($obj->isa("OWL::Frame")) {
        return $self->renderFrame($obj, @_);
    }
    else {
        
    }
}

sub renderOntology {
    my $self = shift;
    my $ont = shift;
    my $s = "";
    if ($ont->getIRI) {
        $s .= "# Ontology: ".$ont->getIRI()."\n\n";
    }

    my @objs = $ont->getDeclared();

    my %objsByType = ();
    foreach (@objs) {
        my ($decl) = $ont->getAxioms('Declaration', $_);
        my $t = $decl->getEntityType ? $decl->getEntityType : 'UNK';
        push(@{$objsByType{$t}}, $_);
    }

    foreach my $type (keys %objsByType) {
        $s .= "# ENTITY TYPE: $type\n\n";
        foreach my $e (sort @{$objsByType{$type}}) {
            $s .= $self->renderEntity($e, $ont);
            $s .= "\n\n";
        }
    }
    $s.="\n";
    return $s;
}

sub renderEntity {
    my $self = shift;
    my $e = shift;
    my $ont = shift;
    
    my @labels = $ont->getLabels($e);
    my $label = shift @labels;
    if (!$label) {
        $label = $e;
    }
    my $fr = $ont->getFrame($e);
    return "" unless $fr;
    my $type = $fr->getType();
    die $fr unless $type;

    my $s = "## $type: $label\n\n";
    $s .= " * IRI: [$e]($e)\n";

    $s .= "\n### Metadata\n\n";

    $s .= " * Other label: $_\n" foreach @labels;

    foreach my $ax ($ont->getAnnotationAssertionAxioms($e)) {
        my $p = $ax->getProperty();
        if ($p ne OWL::RDFSVocabulary->label) {
            my $v = $ax->getValue();
            $s .= " * ".$self->renderExpression($p,$ont)." : $v\n";
        }
    }

    $s .= "\n### SuperClasses\n\n";

    foreach my $ax ($ont->getAxioms('SubClassOf', $e)) {
        my $super = $ax->getSuperClass;
        $s .= " * ".$self->renderExpression($super, $ont)."\n";
    }

    $s .= "\n### EquivalentTo\n\n";

    foreach my $ax ($ont->getAxioms('EquivalentClasses', $e)) {
        #my @ecs = grep { !($_ eq $e) } ($ax->getArgs());
        my @ecs = ($ax->getArgs());
        $s .= " * ".$self->renderExpression($_, $ont)."\n" foreach @ecs;
    }
    $s .= "\n";
    
    

    #my @axioms = $fr->getAxioms();
    return $s;
}

sub renderExpression {
    my $self = shift;
    my $x = shift;
    my $ont = shift;

    if (ref($x)) {
        my $ts = ' '.$x->getTypeAsManchester.' ';
        my @strargs = map { $self->renderExpression($_, $ont) } $x->getArgs;
        if (@strargs == 2) {
            return $strargs[0] . $ts . $strargs[1];
        }
        elsif ($x->isa('NaryClassAxiom')) {
            return join($ts, @strargs);
        }
        elsif ($x->isa('NaryBooleanClassExpression')) {
            return join($ts, @strargs);
        }
        else {
            return $x->getEntityType() . '(' . join(' ', @strargs . ")");
        }

        #if ($x->isa("OWL::Restriction")) {
        #    return $self->renderExpression($x->getProperty, $ont) . " some " .  $self->renderExpression($x->getFiller, $ont);
        #}
        #if ($x->isa("OWL::ObjectSomeValuesFrom")) {
        #    return $self->renderExpression($x->getProperty, $ont) . " some " .  $self->renderExpression($x->getFiller, $ont);
        #}
        ## TODO
        #return ref($x) . '(' . join(' ', @strargs . ")";
    }

    my ($label) = $ont->getLabels($x);
    if (!$label) {
        $label = $x;
        $label =~ s/.*\///;
        $label =~ s/.*\#//;
    }
    return "[$label]($x)";

    
}


1;

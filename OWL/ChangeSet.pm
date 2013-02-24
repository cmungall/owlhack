package OWL::ChangeSet;
use OWL::Renderer::FunctionalRenderer;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless {}, $class;
    $this->{changes} = [@_];
    return $this;
}

sub writeDelta {
    my $self = shift;

    my $in = shift;
    my $out = shift;

    my @changes = @{$this->{changes}};

    my $rmOntFn = "$in.minusAxioms";
    my $addOntFn = "$in.plusAxioms";

    my @rmAxioms = grep {$_->getType eq 'RemoveAxiom'} @changes;
    my @addAxioms = grep {$_->getType eq 'AddAxiom'} @changes;
    #printf STDERR "Num: %d\n", scalar(@rmAxioms);
    
    my $r = OWL::Renderer::FunctionalRenderer->new();
    my $rmOnt = OWL::Ontology->new({axioms=>[@rmAxioms]});
    
    $r->save($rmOnt,$rmOntFn);

    my $addOnt = OWL::Ontology->new({axioms=>[@addAxioms]});
    $r->save($addOnt,$addOntFn);

    my $cmd = "owltools $in --apply-patch $rmOntFn $addOntFn -o file://`pwd`/$out";
    if (system($cmd)) {
        die "$cmd";
    }
    return $out;
}


1;

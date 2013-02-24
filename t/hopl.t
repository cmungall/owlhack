use OWL;
use OWL::HOPL;
use strict;

my $ont = OWL->load("t/data/caro.owl");
my $hopl = OWL::HOPL->new($ont);
my @changes = $hopl->process( 
    sub {
        my ($axiom,$ont) = @_;
        if ($axiom->isa('SubClassOf') && $axiom->getSuperClass()->isa("ObjectSomeValuesFrom")) {
            my $new_axiom = OWL->createAxiom('SubClassOf',$axiom->getSuperClass()->getFiller, $axiom->getSubClass);
            return $new_axiom;
        }
        return;
    });
    

foreach (@changes) {
    print "CH: $_\n";
}



exit 0;






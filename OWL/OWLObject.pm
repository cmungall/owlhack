
package OWL::OWLObject;

use overload '""' => sub {shift->to_string()};

sub getObjectsInSignature {
    return shift->getArgs();
}

sub getArgs {
    my $self = shift;
    # in future may exclude annotations
    return @$self;
}

sub isAbout {
    my ($self,$obj) = @_;
    # may be overridden; default is 0th argument denotes the subject of the axiom
    my $mainArg = $self->[0];
    return "$mainArg" eq "$obj";
}

sub getAnnotations {
    my $self = shift;
    die "not implemented";
}

sub to_string {
    my $self = shift;
    my $type = shift;
    if (!ref($self)) {
        if ($type eq 'Value') {
            # EEEK TODO
            return '"'.$self.'"';
        }
        return "<".$self.">";
    }
    my $n=0;
    my @tArgs = map {
        my $xtype = ref($self);
        if ($META{$xtype}) {
            # hack
            my $nxtype = $META{$xtype}->[$n];
            #die "X: $xtype // $nxtype $n";
            $xtype = $nxtype;
        }
        $n++;
        to_string($_, $xtype)
    } @$self;
    return ref($self) . "(" . join(" ",@tArgs) . ")";
}

sub objectsInSignature {
    my $self = shift;
    if (!ref($self)) {
        return $self;
    }
    return map { $self->objectsInSignature($_) } @$self
}

#sub getProperty {shift->[0]};
our %META =
    (
     'Declaration' => [qw(EntityType Entity)],
     'AnnotationAssertion' => [qw(Property Subject Value)],
     'ObjectPropertyAssertion' => [qw(Property Subject Value)],
     'ClassAssertion' => [qw(ClassExpression Individual)],
     'SubClassOf' => [qw(SubClass SuperClass)],
     'ObjectSomeValuesFrom' => [qw(Property Filler)],
    );

my %ARGMAP = ();

sub initARGMAP {
    #print STDERR "INIT...\n";
    foreach my $type (keys %META) {
        #print STDERR "T $type\n";
        my $i = 0;
        my @fields = @{$META{$type}};
        foreach (@fields) {
            #print STDERR " F: $_\n";
            $ARGMAP{$type}->{$_} = $i;
            $i++;
        }
    }
}

sub AUTOLOAD {
    
    my $self = shift;

    if (!%ARGMAP) {
        initARGMAP();
    }

    my $name = $AUTOLOAD;
    $name =~ s/.*://;   # strip fully-qualified portion

    if ($name eq "DESTROY") {
	# we dont want to propagate this!!
	return;
    }

    confess("$self") unless ref($self);
    
    if ($name =~ /get(.+)/) {
        my $ix = $ARGMAP{ref($self)}->{$1};
        return $self->[$ix];
    }

    die("can't do $name on $self");
    
}

package OWL::Axiom;
use base OWL::OWLObject;

package ClassExpression;
use base OWL::OWLObject;

package Declaration;
use base OWL::Axiom;
sub isAbout { return shift->[1] eq shift }

package AnnotationAssertion;
use base OWL::Axiom;
sub isAbout { return shift->[1] eq shift }

package ClassAssertion;
use base OWL::Axiom;
sub isAbout { return shift->[1] eq shift }

package InverseObjectProperties;
use base OWL::Axiom;

package SubClassOf;
use base OWL::Axiom;

package SubPropertyOf;
use base OWL::Axiom;

package SubAnnotationPropertyOf;
use base SubPropertyOf;

package SubObjectPropertyOf;
use base SubPropertyOf;

package SubPropertyChainOf;
use base SubPropertyOf;

package NaryClassAxiom;
use base OWL::Axiom;
sub getClassExpressions { return shift->getArgs }
sub isSubject { my $self = shift; my $obj = shift; return scalar(grep {$_ eq $obj} $self->getClassExpressions() )}

package EquivalentClasses;
use base NaryClassAxiom;

package DisjointClasses;
use base NaryClassAxiom;

package PropertyAssertion;
use base OWL::Axiom;
sub isAbout { return shift->[1] eq shift }

package ObjectPropertyAssertion;
use base PropertyAssertion;

package DataPropertyAssertion;
use base PropertyAssertion;
package AnnotationPropertyAssertion;
use base PropertyAssertion;

# - CLASS EXPRESSIONS -
package ObjectIntersectionOf;
use base ClassExpression;

package Restriction;
use base ClassExpression;

package ObjectSomeValuesFrom;
use base Restriction;

package ObjectAllValuesFrom;
use base Restriction;

package CardinalityRestriction;
use base Restriction;

package ObjectExactCardinality;
use base CardinalityRestriction;

package Characteristic; use base OWL::Axiom;
package TransitiveObjectProperty; use base Characteristic;

package Literal; use base OWL::OWLObject;
sub to_ofn {
    my $self = shift;
    my $v = $self->[1];
    $v =~ s/\"/\\\"/g;
    return sprintf('"%s"^^%s"',$v,$self->[0]);
}
sub to_string {
    my $self = shift;
    return $self->[1];
}
1;

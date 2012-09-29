
package OWL::OWLObject;

use overload '""' => sub {shift->to_string()};

sub getArgs {
    my $self = shift;
    # in future may exclude annotations
    return @$self;
}

sub isAbout {
    my ($self,$obj) = @_;
    # may be overridden; default is 0th argument denotes the subject of the axiom
    return $self->[0] eq $obj;
}

sub getAnnotations {
    my $self = shift;
    die "not implemented";
}

sub to_string {
    my $self = shift;
    if (!ref($self)) {
        return $self;
    }
    return ref($self) . "(" . join(" ",map {to_string($_)} @$self) . ")";
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
     'AnnotationAssertion' => [qw(Property Subject Value)],
     'SubClassOf' => [qw(SubClass SuperClass)],
    );

my %ARGMAP = ();

sub initARGMAP {
    print STDERR "INIT...\n";
    foreach my $type (keys %META) {
        #print STDERR "T $type\n";
        my $i = 0;
        my @fields = @{$META{$type}};
        foreach (@fields) {
            print STDERR " F: $_\n";
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

package Axiom;
use base OWL::OWLObject;

package ClassExpression;
use base OWL::OWLObject;

package AnnotationAssertion;
use base Axiom;

package SubClassOf;
use base Axiom;

package NaryClassAxiom;
use base Axiom;
sub getClassExpressions { return shift->getArgs }
sub isSubject { my $self = shift; my $obj = shift; return scalar(grep {$_ eq $obj} $self->getClassExpressions() )}

package EquivalentClasses;
use base NaryClassAxiom;

package DisjointClasses;
use base NaryClassAxiom;

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
1;

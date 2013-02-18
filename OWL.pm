package OWL;
use OWL::Ontology;
use JSON;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $this = bless shift, $class;
    $this->init();
    return $this;
}

sub init {
    
}

sub loadFromJS {
    my $self = shift;
    my $f = shift;
    open(F,$f) || die "cannot open $f";
    my $jsonStr = join("\n", <F>);
    my $ontHash = JSON->new->decode( $jsonStr );
    my $ont = OWL::Ontology->new($ontHash);
    return $ont;
}

sub load {
    my $self = shift;
    my $f = shift;
    if ($f =~ /\.ojs$/) {
        return $self->loadFromJS($f,@_);
    }
    my $f2 = "$f.ojs";
    if (-f $f2 && (stat($f))[9] <= (stat($f2))[9]) {
        return $self->loadFromJS("$f2", @_);
    }
    my $err = system("owltools $f -o -f ojs $f2 > /dev/null");
    if (!$err) {
        return $self->loadFromJS("$f2", @_);
    }
    die $f;
}

sub createAxiom {
    my $self = shift;
    return OWL::Ontology::h2obj({type=>shift, args=>[@_]});
}

1;


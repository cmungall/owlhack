package OWL::Renderer;

sub save {
    my ($self, $ont, $file) = @_;
    open(F, ">$file") || die "cannot write to $file";
    print F $self->render($ont);
    close(F);
}

1;

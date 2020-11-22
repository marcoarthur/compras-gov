package Compras::Model::Roles::ExtendedAttrs;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Hash::Flatten qw(flatten);

sub install_acessors_from_links($self) {
    my $extra = $self->_other->{_links};
    return unless defined $extra && ref $extra eq 'HASH';

    my %opts      = ( HashDelimiter => '_' );
    my $flattened = flatten( $extra, \%opts );

    for my $field ( keys %$flattened ) {

        # hack to remove a escape sequence (bug to option DisableEscapes)
        # https://rt.cpan.org/Public/Bug/Display.html?id=84033
        $field =~ s/\\+//g;
        if ( exists $self->{$field} ) {
            raise 'Compras::Exception', "$field already an attribute of $self";
            next;
        }

        $self->attr($field);                                      #install
        $self->$field( $flattened->{$field} );                    #set value
        $self->attributes->{$field} = "atributo extra $field";    #update attributes
    }
}

# hook it into object creation from hash
after from_hash => sub {
    my $self = shift;
    $self->install_acessors_from_links;
};

1;

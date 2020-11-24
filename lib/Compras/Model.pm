package Compras::Model;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);

has attributes => sub { +{} };

sub from_hash ( $self, $hash ) {
    raise 'Compras::Exception', "Not a hash ref" unless ref $hash eq 'HASH';

    for my $attr ( keys %{ $self->attributes } ) {
        raise 'Compras::Exception', "Cannot find $attr"
          unless exists $hash->{$attr};
        $self->attr($attr);
        $self->$attr( $hash->{$attr} );
        delete %$hash{$attr};
    }

    # save under _other the data left under $hash not listed on attributes
    $self->attr('_other');
    $self->_other($hash);
    $self;
}

sub to_hash( $self ) {
    my %hash = map { $_ => $self->$_ } keys %{ $self->attributes };
    return \%hash;
}

sub to_arrayref( $self ) {
    my $keys   = $self->attributes_order;
    my @values = @{ $self->to_hash }{@$keys};
    return \@values;
}

sub attributes_order( $self ) {
    my @sorted_attrs = sort keys %{ $self->attributes };
    return \@sorted_attrs;
}

sub add_to_attrs ( $self, $attr, $description ) {
    $self->attributes->{$attr} = $description;
}

1;

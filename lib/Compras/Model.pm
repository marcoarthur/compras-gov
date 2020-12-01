package Compras::Model;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);

has attributes => sub { +{} };

# common template for most models
has template => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/v1/$method.$format} );
    % $url->query->merge( %{ $params } );
	<%== $url->to_abs =%>
EOT
};

# common json response structure for most models
has json_res_structure => sub {
    return {
        results => '/_embedded',
        links   => '/_links',
        count   => '/count',
        offset  => '/offset',
    };
};

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

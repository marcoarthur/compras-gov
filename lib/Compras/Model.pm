package Compras::Model;
use Mojo::Base 'Mojo::EventEmitter', -signatures;
use Mojo::Exception qw(raise);

has attributes  => sub { +{} };

# common template for most models
has template => sub {
    return <<'EOT';
    % use Mojo::URL;
    % my $url = Mojo::URL->new( qq{$base/$module/v1/$method.$format} );
    % $url->query->merge( %{ $params } );
    <%= $url->to_abs =%>
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

has _initialized => sub { return 0; };

sub from_hash ( $self, $hash ) {
    return if $self->_initialized;
    raise 'Compras::Exception', "Not a hash ref" unless ref $hash eq 'HASH';

    for my $attr ( keys %{ $self->attributes } ) {
        raise 'Compras::Exception', "Cannot find $attr"
          unless exists $hash->{$attr};
        $self->_set_attr( $attr, $hash->{$attr} );
        delete %$hash{$attr};
    }

    # save under _other the data left under $hash not listed on attributes
    $self->_set_attr( '_other', $hash );
    $self->_initialized(1);
}

sub _set_attr ( $self, $attr_name, $value ) {
    return if $self->can($attr_name);
    $self->attr($attr_name);
    $self->$attr_name($value);
    $self->emit( attr_set => { name => $attr_name, value => $value } );
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

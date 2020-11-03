package Compras::Model;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);

has attributes => sub { +{} };

sub from_hash ( $self, $hash ) {
    raise 'Compras::Exception', "Not a hash ref" unless ref $hash eq 'HASH';

    for my $attr ( keys %{ $self->attributes } ) {
        raise 'Compras::Exception', "Cannot find $attr"
          unless exists $hash->{$attr};
        $self->attr( $attr );
	$self->$attr($hash->{$attr});
    }
    $self;
}

1;

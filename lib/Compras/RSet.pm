package Compras::RSet;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);

has tx => sub { die "Required attrib tx" };

# validate http request result
sub _validate( $self ) {
    if ( $self->tx->res->code != 200 ) {
        raise 'Compras::Exception', "Invalid Server Response";
    }
    return 1;
}

sub parse( $self ) {
    $self->_validate();
    my $content_type = lc $self->tx->res->headers->content_type;
    my $result_set;

    if ( $content_type =~ qr{application/json} ) {
        my $res_obj = $self->tx->res->json;
        $result_set = $self->_parse_model_json( $res_obj );
    } else {
        $result_set = $self->_parse_model_other( $self->tx->res->body );
    }

    return $result_set;
}

# Parse a JSON object
sub _parse_model_json( $self, $res_obj ) {
    return $res_obj;
}

# Parse Html or CSS or other type
sub _parse_model_other( $self, $data ) {
    return $data;
}

1;

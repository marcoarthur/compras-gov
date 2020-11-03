package Compras::RSet;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);
use Mojo::JSON::Pointer;

has tx => sub { die "Required attrib tx" };
has json_structure => sub {
	{
		results => '/_embedded',
		links => '/_links',
		count => '/count',
		offset => '/offset',
	}
};

# validate json response structure
sub _validate_json( $self, $json_obj )  {
    my $pointer = Mojo::JSON::Pointer->new($json_obj);
    my $parsed = {};

    while( my ($key, $member) = each %{ $self->json_structure } ) {
	if ( ! $pointer->contains($member) )  {
	    raise 'Compras::Exception', "Invalid Server Response missing $member";
	}
	$parsed->{ $key } = $pointer->get($member);
    }
    return $parsed;
}

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
    my $structure = $self->_validate_json($res_obj);
    return $structure;
}

# Parse Html or CSS or other type
sub _parse_model_other( $self, $data ) {
    return $data;
}

1;

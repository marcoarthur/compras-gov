package Compras::RSet;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);
use Mojo::JSON::Pointer;
use Mojo::Collection;
use Mojo::Loader qw(load_class);
use Mojo::Log;
use utf8;

has tx             => sub { die "Required attrib tx" };
has json_structure => sub {
    {
        results => '/_embedded',
        links   => '/_links',
        count   => '/count',
        offset  => '/offset',
    }
};

has models_table => sub {
    {
        fornecedores => 'Compras::Model::Providers',
        licitacoes   => 'Compras::Model::Bids',
        orgaos       => 'Compras::Model::Institutions',
        contratos    => 'Compras::Model::Contracts',
        pregoes      => 'Compras::Model::TradingFloors',
        irps         => 'Compras::Model::IRPS',
        materiais    => 'Compras::Model::Materials',
        servicos     => 'Compras::Model::Services',
    }
};

has _log => sub { Mojo::Log->new };

sub _determine_model ( $self, $type ) {
    my $class = $self->models_table->{$type};
    raise "Compras::Exception", "Cannot find a model for $type" unless $class;
    my $e = load_class($class);
    raise "Compras::Exception", "Error ($e) loading class: $class" if $e;
    return $class;
}

# validate json response structure
sub _validate_json ( $self, $json_obj ) {
    my $pointer = Mojo::JSON::Pointer->new($json_obj);
    my ( $parsed, $val ) = ( {}, undef );

    while ( my ( $key, $member ) = each %{ $self->json_structure } ) {
        if ( !$pointer->contains($member) ) {
            raise 'Compras::Exception', "Invalid Server Response missing $member";
        }
        $val = $pointer->get($member);
        $parsed->{$key} = $val;
    }

    # not a data collection: treat it as data definition
    # and assume model "as is".
    $val = $pointer->get('/_embedded');
    if ( !$val ) {
        $parsed->{results} = $json_obj;
        return $parsed;
    }

    # otherwise:  is a data collection and we parse using models
    my @types = keys %$val;
    if ( @types > 1 ) {
        raise "Compras::Exception", "More than one type: @types";
    }

    # construct the model from hash
    my $type    = shift @types;
    my $results = $val->{$type};
    my $class   = $self->_determine_model( lc $type );
    raise "Compras::Exception", "Server results are not a list: $results"
      unless ref $results eq 'ARRAY';
    my $collection = Mojo::Collection->new(@$results)->map( sub { $class->new->from_hash($_) } );
    $parsed->{results} = $collection;

    return $parsed;
}

# validate http request result
sub _validate( $self ) {
    my $code = $self->tx->res->code;
    if ( $code != 200 ) {
        raise 'Compras::Exception', "Invalid Server Response: $code";
    }
    return 1;
}

sub parse( $self ) {
    $self->_validate();
    my $content_type = lc $self->tx->res->headers->content_type;
    my $result_set;

    if ( $content_type =~ qr{application/json} ) {
        my $res_obj = $self->tx->res->json;
        $result_set = $self->_parse_model_json($res_obj);
    } else {
        $result_set = $self->_parse_model_other( $self->tx->res->body );
    }

    return $result_set;
}

# Parse a JSON object
sub _parse_model_json ( $self, $res_obj ) {
    my $structure = $self->_validate_json($res_obj);
    return $structure;
}

# Parse Html or CSS or other type
sub _parse_model_other ( $self, $data ) {
    return $data;
}

1;

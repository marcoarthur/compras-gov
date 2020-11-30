package Compras::RSet;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);
use Mojo::JSON::Pointer;
use Mojo::Collection;
use Mojo::Loader qw(load_class find_modules);
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
    state $table = shift->_build_model_table;
};

has _log => sub { Mojo::Log->new };

sub _load_models ( $self ) {
    my $namespace = 'Compras::Model';
    my @models;
    for my $model ( find_modules $namespace ) {
        my $e = load_class $model;
        raise "Compras::Exception", "Error($e) loading model $model" if $e;
        push @models, $model;
    }

    return Mojo::Collection->new(@models);
}

sub _build_model_table( $self ) {
    my $models = $self->_load_models;
    my %table;
    $models->each(
        sub ( $class, $index ) {
            my $obj = $class->new;
            $table{ $obj->model_name } = $class;
        }
    );

    return \%table;
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
    my $class   = $self->models_table->{ lc($type) };
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

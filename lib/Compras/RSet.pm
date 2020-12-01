package Compras::RSet;
use Mojo::Base -base, -signatures;
use Mojo::Exception qw(raise);
use Mojo::JSON::Pointer;
use Mojo::Collection;
use Mojo::Log;
use Compras::Utils qw(load_models);
use utf8;

has tx             => sub { die "Required attrib tx" };
has json_structure => sub { die "Required json structure to parse" };
has 'model_name';

has models_table => sub {
    state $table = shift->_build_model_table;
};

has _log => sub { Mojo::Log->new };

sub _build_model_table( $self ) {
    my $models = load_models;
    my %table;
    $models->each(
        sub ( $class, $index ) {
            my $name = $class->new->model_name;
            $name =~ s/_+//;
            $table{ lc($name) } = $class;
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

    # not a data collection: treat it data for one model only
    $val = $pointer->get('/_embedded');
    if ( !$val ) {
        my $class = $self->_build_model_table->{ $self->model_name };
        $parsed->{results} = Mojo::Collection->new( $class->new->from_hash($json_obj) );
        return $parsed;
    }

    # otherwise:  is a data collection and we parse using models
    my @types = keys %$val;
    if ( @types > 1 ) {
        raise "Compras::Exception", "More than one type: @types";
    }

    # construct the model from hash
    use DDP;
    my $type    = shift @types;
    $type =~ s/_+//; #remove underlines
    my $results = $val->{$type};
    my $class   = $self->models_table->{ lc($type) };
    raise "Compras::Exception", "Can't found a model for $type" unless $class;
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

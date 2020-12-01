package Compras::Search;
use Mojo::Base -base, -signatures;

use Compras::UA;
use Compras::Utils qw(load_models);
use Digest::MD5 qw(md5_hex);
use List::Util qw(first all);
use Mojo::Exception qw(raise);
use Mojo::JSON qw(encode_json decode_json);
use Mojo::Loader qw(find_modules);
use Mojo::Log;
use Mojo::Redis;
use Safe::Isa;
use Syntax::Keyword::Try;

our $HIST = {};

has base   => sub { 'http://compras.dados.gov.br' };
has format => sub { 'json' };
has log    => sub { state $log = Mojo::Log->new };
has roles  => sub { [] };
has query  => sub { die "Need a defined query" };

has _templ => sub { Mojo::Template->new };

# parses the query structure to check if module contains this method as
# compras.gov.br defines in their docs
sub _parse_search( $self ) {
    my $models = load_models;

    # extract modules and methods as defined by models
    my ( %modules, %model_objs );
    $models->each(
        sub ( $class, $index ) {
            my $obj = $class->new;
            $model_objs{ $obj->model_name } = $obj;
            my $list = $modules{ $obj->from_module } || [];
            push @$list, $obj->model_name;
            $modules{ $obj->from_module } = $list;
        }
    );

    $self->_check_query_structure;
    $self->_check_module_consistence( \%modules );

    # get template string for query
    my $q = $self->query;
    my ( $module, $method ) = @$q{qw(module method)};
    my $model_name = first { $_ eq $method } @{ $modules{$module} };
    my $model      = $model_objs{$model_name};

    # check search parameter consistency
    my $allowable_search_params = $model->search_parameters;
    my @search_params           = keys %{ $self->query->{params} };
    my @unknowns                = grep { !exists $allowable_search_params->{$_} } @search_params;

    if (@unknowns) {
        raise 'Compras::Exception', "Unknown(s) search parameter(s): @unknowns";
    }

    # fullfill template string with query variables
    my $tmpl_params = {
        base   => $self->base,
        format => $self->format,
        %{ $self->query }
    };
    my $url = $self->_templ->vars(1)->render( $model->template, $tmpl_params );
    return $url, $model;
}

# check query highlevel parameters
sub _check_query_structure( $self ) {
    my @mandatory = qw(module);
    my @optional  = qw(method params model);
    my $q         = $self->query;

    unless ( all { defined $_ } @$q{@mandatory} ) {
        raise 'Compras::Exception', "Missing a mandatory @mandatory parameter";
    }

    # set default method
    $q->{method} = $q->{module} unless $q->{method};

    for my $param ( keys %$q ) {
        my $known = first { $_ eq $param } ( @mandatory, @optional );
        raise 'Compras::Exception', "Unknown search parameter: $param" unless $known;
    }
}

sub _check_module_consistence ( $self, $modules ) {
    my $q = $self->query;
    my ( $method, $module ) = @$q{qw(method module)};
    my $m = first { $_ eq $method } @{ $modules->{$module} };
    raise 'Compras::Exception', "Invalid method $method for module $module" unless $m;
}

sub search ( $self ) {

    my ( $url, $model ) = $self->_parse_search;
    my $ua = Compras::UA->new(
        response_structure => $model->json_res_structure,
        model_name         => $model->model_name,
    );

    $self->log->info("Fetching from server");
    try {

        my $res = $ua->get_data($url);

        # model collection: apply any role and transform in hash
        if ( $res->{results}->$_isa('Mojo::Collection') ) {
            $self->_apply_role( $res->{results} );
        }
        return $res;
    } catch ($e) {
        raise 'Compras::Exception', "Error querying $url: $e";
    }
}

sub _apply_role ( $self, $collection ) {
    return unless @{ $self->roles } > 0;
    my @all = find_modules 'Compras::Model::Roles';

    for my $role ( @{ $self->roles } ) {
        my $m = first { $_ eq $role } @all;
        raise 'Compras::Exception', "Role $role Not found" unless $m;
        $collection->each( sub { $_->with_roles($role); } );
    }
}

1;

__END__

=encoding utf8

=head1 NAME

Compras::Search - Search interface to Compras::UA

=head1 SYNOPSIS

Interface handling cache to Compras::UA. Making less stressful for the server.
It depends on Redis database. It can be configured under ~/.compras/redis.conf

=head1 DESCRIPTION

A module to search and cache results of search. It depends on C<Mojo::Redis> as
cache object. It can be configured using configure file.

=head1 ATTRIBUTES

=head2 cache

A Mojo::Redis handler.

=head2 log

A Logger Object default Mojo::Log

=head2 roles

A hash reference containing Roles to apply to basic Compras::Model.

=head1 METHODS

=head2 key($query)

Calculate the key of query. Based on query and Roles

=head2 search($hashref)

  $self->search( { module => licitacoes, params => { valor_inicial_min => 1000 } } )

Execute the query caching it. It will rerun the query on server given if query
had expired.

=head1 AUTHOR

Marco Arthur,,,

=head1 COPYRIGHT AND LICENSE


This is Free Software, Licensed under Perl License.

=head1 SEE ALSO

Compras::UA

=cut

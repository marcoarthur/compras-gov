package Compras::Search;
use Mojo::Base -base, -signatures;

use Compras::UA;
use Compras::Utils qw(load_models model_from_query);
use Digest::MD5 qw(md5_hex);
use List::Util qw(first all);
use Mojo::Exception qw(raise);
use Mojo::JSON qw(encode_json decode_json);
use Mojo::Loader qw(find_modules);
use Mojo::Log;
use Safe::Isa;
use Syntax::Keyword::Try;
our $VERSION = "0.05";

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
    my $model = model_from_query( $self->query );

    raise "Compras::Exception", "Error could not find a model for your query" unless $model;

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
    my @optional  = qw(method params model submethod);
    my $q         = $self->query;

    unless ( all { defined $_ } @$q{@mandatory} ) {
        raise 'Compras::Exception', "Missing a mandatory @mandatory parameter";
    }

    # set default method
    $q->{method} = $q->{module} unless $q->{method};

    # TODO: should be first check above other two.
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
    my $ua = Compras::UA->new( model => $model );

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


=encoding utf-8

=head1 NAME

Compras::Search - Client API to Brazil bid system (http://compras.dados.gov.br/)

=head1 INSTALL

To install it you will need perl (5.028 or later) and L<cpanm|https://metacpan.org/pod/distribution/App-cpanminus/bin/cpanm>

    $ git clone https://github.com/marcoarthur/compras-gov.git
    $ cd compras-gov
    $ cpanm --installdeps .

We provide a script to try out some searches

    $ ./script/search.pl [1-4] # each number is a search 

=head1 SYNOPSIS

    use Compras::UA;
    use DDP;
    my $ua = Compras::UA->new( { module => 'licitacoes', params => { valor_inicial => 100000 } } );
    my $data = $ua->get_data->{results};
    p $data; # will print a Collection of Compras::Model::Contracts

=head1 DESCRIPTION

The goal is to handle all models as provided L<here|http://compras.dados.gov.br/docs/home.html>

When constructing C<Compras::UA> we pass to the constructor the terms of our search.
We list these terms, examplifing it, bellow:

=over 4

=item module:

The entitie we want data, eg, 'licitacoes' L<details|http://compras.dados.gov.br/docs/detalhe-licitacao.html>

=item method:

This is the actual data the module can provide, eg, 'orgaos' L<details|http://compras.dados.gov.br/docs/licitacoes/v1/orgaos.html>

=item params: 

Any search parameters for the method invoked, eg, 'nome' for 'orgaos'

=item format: 

The format of response, by default json. Acceptable values are: html, csv.

=back

So the search bellow represents and returns all institutions named 'TRIBUNAL' that have bids listed.

    try {
        my $res = $self->search( { module => licitacoes, params => { valor_inicial_min => 1000 } } )
        $res->{results}->each( sub { $_->nome } );
    } catch ($e) {
        warn "Error $e";
    }


The results are a collection of Models determined by the module parameter.
Models holds the data that is listed in the documentation for, eg, the above
search returns Compras::Model::Institutions that contains accessors for
each listed response the server documents, eg in this case:

    $ele->$_ for qw( ativo codigo codigo_siorg codigo_tipo_adm codigo_tipo_esfera codigo_tipo_poder nome)
    # prints value of all model public accessor

You can get a list on Server doc or looking at the Models classes.

=head2 get_data

   my $ret = $ua->get_data;
   $ret->{results}->each( sub ($e, $n) { say join ' ', @{ $e->to_arrayref} } );

Returns hash reference containing data of the search. It runs many searches if the results cannot be completed
in only one requests. Server handles at most 500 records per request. Those will
be concurrent requests. Under C<results> key is the array reference with the
data.

=head2 url

    say $ua->url;

Returns the url that was requested.

=head1 LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=cut

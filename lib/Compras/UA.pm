package Compras::UA;
use 5.028;
use Mojo::Base -base, -signatures, -async_await;
use Mojo::Template;
use Mojo::UserAgent;
use Mojo::Log;
use Compras::RSet;
use Mojo::Exception qw(raise);
our $VERSION = "0.04";
use constant TIMEOUT     => 120;
use constant MAX_RECORDS => 500;

has log_level          => sub { 'debug' };
has model_name         => sub { die 'Required model name' };
has response_structure => sub { die 'Required response structure' };

has tout  => sub { TIMEOUT };
has _hist => sub { +{} };
has _log  => sub { Mojo::Log->new( level => shift->log_level ) };
has _ua   => sub { Mojo::UserAgent->new->inactivity_timeout( shift->tout )->max_redirects(5) };

# non blocking
async sub get_data_p ( $self, $url ) {
    return $self->_ua->get_p($url);
}

# blocking
sub get_data ( $self, $url ) {
    my $cached = $self->_hist->{$url};
    return $cached if $cached;

    $self->_log->info("Getting data from $url");
    my ( $rs, $e, $res );

    $self->get_data_p($url)->then(
        sub ($tx) {
            my $params = {
                tx             => $tx,
                json_structure => $self->response_structure,
                model_name     => $self->model_name
            };
            $rs  = Compras::RSet->new($params);
            $res = $rs->parse;
        }
    )->catch(
        sub ($err) {
            $self->_log->fatal("Error: $err with url: $url");
            $e = $err;
        }
    )->wait;

    if ($e) {
        raise "Compras::Exception", "Check your internet connection: $e";
        return;
    }

    # After the first request: check if we need more request to fullfill
    # records missing. Make concurrent calls to receive the rest of records.
    # (Serve response with maximum 500 records per request)
    my $total  = $res->{count} || 0;
    my $amount = $res->{results}->size;
    my @promises;
    my $remain = Mojo::URL->new($url);

    while ( $total > $amount ) {
        $remain->merge( { offset => $amount } );
        $self->increase_timeout(5);
        push @promises, $self->get_data_p($remain)->then(
            sub ($tx) {
                $rs->tx($tx);
                my $partial = $rs->parse->{results};
                push @{ $res->{results} }, @{$partial};
                my $size = $partial->size;
                $self->_log->info("Retrivied $size records from $total total");
            }
        )->catch(
            sub ($err) {
                $self->_log->fatal( "Error: $err with url: " . $url );
            }
        );
        $amount += MAX_RECORDS;
    }

    # has records to resolve: fetch then all
    if (@promises) {
        Mojo::Promise->all_settled(@promises)->then(
            sub (@p) {
                $self->_log->info( "Total " . $res->{results}->size . " records retrieved" );
            }
        )->wait;
    }

    # save in history
    $self->_hist->{$url} = $res;
    return $res;
}

sub increase_timeout ( $self, $inc ) {
    my $timeout = $self->tout;
    $self->tout( $timeout + $inc );
    $self->_ua->inactivity_timeout( $self->tout );
}

1;

__END__

=encoding utf-8

=head1 NAME

Compras::UA - Client API to Brazil bid system (http://compras.dados.gov.br/)

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

    my $ua = Compras::UA->new( { module => 'licitacoes',  method => 'orgaos', params => { nome => 'TRIBUNAL' } } );
    try {
        my $res = $ua->get_data;
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

package Compras::UA;
use 5.028;
use Mojo::Base -base, -signatures, -async_await;
use Mojo::Template;
use Mojo::UserAgent;
use Mojo::Log;
use Compras::RSet;
use Mojo::Exception qw(raise);
our $VERSION = "0.01";
use constant TIMEOUT     => 120;
use constant MAX_RECORDS => 500;

has base   => sub { 'http://compras.dados.gov.br' };
has module => sub { die "module is required" };
has method => sub { shift->module or die "method is required" };
has format => sub { 'json' };
has params => sub { +{} };
has tout   => sub { TIMEOUT };
has _ua    => sub { Mojo::UserAgent->new->inactivity_timeout( shift->tout ) };
has _templ => sub { Mojo::Template->new };
has _hist  => sub { +{} };
has _req   => sub {
    <<'EOT';
	% my $url = qq{$base/$module/v1/$method.$format};
	% my $params = join "&", map { qq($_=$params->{$_}) } keys %$params;
	% $url = $params ? join("?", $url, $params) : $url;
	<%= $url =%>
EOT
};

# request to entities definition. That follows other url scheme
has _dreq => sub {
    <<'EOT';
	% my $url = qq{$base/$module/doc/$method/$id.$format};
	<%= $url =%>
EOT
};
has req_def => sub { undef };
has _log    => sub { Mojo::Log->new };

sub url ( $self ) {
    my $params = { map { $_ => $self->$_ } qw( base module method format params ) };
    return $self->_templ->vars(1)->render( $self->_req, $params ) unless $self->req_def;

    delete $params->{params};
    $params->{id} = $self->params->{id}
      or raise "Compras::Exception", "Missing id in parameters";
    return $self->_templ->vars(1)->render( $self->_dreq, $params );
}

# non blocking
async sub get_data_p( $self ) {
    return $self->_ua->get_p( $self->url );
}

# blocking
sub get_data( $self ) {
    my ( $res, $format, $url ) = ( undef, $self->format, $self->url );
    my $cached = $self->_hist->{$url};
    return $cached if $cached;

    $self->_log->info("Getting data from $url");
    my ( $rs, $e );

    $self->get_data_p->then(
        sub ($tx) {
            my $params = { tx => $tx };

            # change default json_structure expected if we we are requesting definition
            $params->{json_structure} = { links => '/_links' } if $self->req_def;
            $rs                       = Compras::RSet->new($params);
            $res                      = $rs->parse;
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

    # not a data collection: just save response and return it
    if ( $self->req_def ) {
        $self->_hist->{$url} = $res;
        return $res;
    }

    # After the first request: check if we need more request to fullfill
    # records missing. Make concurrent calls to receive the rest of records.
    # (Serve response with maximum 500 records per request)
    my $total  = $res->{count};
    my $amount = $res->{results}->size;
    my @promises;

    while ( $total > $amount ) {
        $self->params->{offset} = $amount;
        my $url = $self->url;
        $self->increase_timeout(5);
        push @promises, $self->get_data_p->then(
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

sub increase_timeout( $self, $inc ) {
    my $timeout = $self->tout;
    $self->tout($timeout + $inc);
    $self->_ua->inactivity_timeout($self->tout);
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

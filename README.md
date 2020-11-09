# NAME

Compras::UA - Client API to Brazil bid system (http://compras.dados.gov.br/)

# INSTALL

To install it you will need perl (5.028 or later) and [cpanm](https://metacpan.org/pod/distribution/App-cpanminus/bin/cpanm)

    $ git clone https://github.com/marcoarthur/compras-gov.git
    $ cd compras-gov
    $ cpanm --install-deps .

We provide a script to try out some searches

    $ ./script/search.pl [1-4] # each number is a search 

# SYNOPSIS

    use Compras::UA;
    use DDP;
    my $ua = Compras::UA->new( { module => 'licitacoes', params => { valor_inicial => 100000 } } );
    my $data = $ua->get_data->{results};
    p $data; # will print a Collection of Compras::Model::Contracts

# DESCRIPTION

The goal is to handle all models as provided [here](http://compras.dados.gov.br/docs/home.html)

When constructing `Compras::UA` we pass to the constructor the terms of our search.
We list these terms, examplifing it, bellow:

- module:

    The entitie we want data, eg, 'licitacoes' [details](http://compras.dados.gov.br/docs/detalhe-licitacao.html)

- method:

    This is the actual data the module can provide, eg, 'orgaos' [details](http://compras.dados.gov.br/docs/licitacoes/v1/orgaos.html)

- params: 

    Any search parameters for the method invoked, eg, 'nome' for 'orgaos'

- format: 

    The format of response, by default json. Acceptable values are: html, csv.

So the search bellow represents and returns all institutions named 'TRIBUNAL' that have bids listed.

    my $ua = Compras::UA->new( { module => 'licitacoes',  method => 'orgaos', params => { nome => 'TRIBUNAL' } } );
    try {
        my $res = $ua->get_data;
        $res->{results}->each( sub { $_->nome } );
    } catch ($e) {
        warn "Error $e";
    }

The results are a collection of Models determined by the `module` parameter.
Models holds the data that is listed in the documentation for, eg, the above
search returns Compras::Model::Institutions that contains accessors for
each listed response the server documents, eg in this case:

    $ele->$_ for qw( ativo codigo codigo_siorg codigo_tipo_adm codigo_tipo_esfera codigo_tipo_poder nome)
    # prints value of all model public accessor

You can get a list on Server doc or looking at the Models classes.

## get\_data

    my $ret = $ua->get_data;
    $ret->{results}->each( sub ($e, $n) { say join ' ', @{ $e->to_arrayref} } );

Returns hash reference containing data of the search. It runs many searches if the results cannot be completed
in only one requests. Server handles at most 500 records per request. Those will
be concurrent requests. Under `results` key is the array reference with the
data.

## url

    say $ua->url;

Returns the url that was requested.

# LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Marco Arthur <arthurpbs@gmail.com>

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 176:

    Deleting unknown formatting code M<>

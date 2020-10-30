use strict;
use Test::More;

use_ok $_ for qw(
Compras::UA
);

my $ua = Compras::UA->new( module => 'licitacoes', method => 'orgaos', params => { nome => 'turismo' });
my $url = $ua->url;

is $url, 'http://compras.dados.gov.br/licitacoes/v1/orgaos.json?nome=turismo', "Url creation ok";
my $data = $ua->get_data;
note explain $data;

done_testing;


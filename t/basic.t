use strict;
use Test::More;
use Mojo::Base -signatures;

use_ok $_ for qw(
  Compras::UA
);

sub build_ua( @args ) {
    return Compras::UA->new( $args[0] ) if $args[0] eq 'HASH';
    return Compras::UA->new(@args);
}

subtest 'Testing model Institution' => sub {
    my $ua =
      build_ua( module => 'licitacoes', method => 'orgaos', params => { nome => 'turismo' } );
    my $url = $ua->url;

    is $url, 'http://compras.dados.gov.br/licitacoes/v1/orgaos.json?nome=turismo',
      "Url creation ok";
    my $data = $ua->get_data;
    isa_ok $data, 'HASH';
    isa_ok $data->{results}, 'Mojo::Collection';
    ok $data, 'data retrieve ok' or note explain $data;
};

subtest 'Testing model TradingFloors' => sub {

    # co_uasg 254448 refers to INSTITUTO NAC. DE CONTROLE E QUALID. EM SAUDE
    my $ua   = build_ua( module => 'pregoes', params => { co_uasg => 254448 } );
    my $data = $ua->get_data;
    my $res  = $data->{results};
    isa_ok $data, 'HASH';
    isa_ok $res,  'Mojo::Collection';
    ok $res->size > 0, 'Has real results';
    isa_ok $res->[0], 'Compras::Model::TradingFloors';

    #note explain $data;
};

done_testing;

use strict;
use Test::More;
use Mojo::Base -signatures;

our $debug = 0;

use_ok $_ for qw(
  Compras::UA
);

sub build_ua( @args ) {
    my $ua = $args[0] eq 'HASH' ? Compras::UA->new( $args[0] ) : Compras::UA->new(@args);
    $ua->log_level('fatal') unless $debug;
    return $ua;
}

sub basic_results_for_model ( $model, $data ) {
    my $res = $data->{results};
    isa_ok $data, 'HASH';
    isa_ok $res,  'Mojo::Collection';
    ok $res->size > 0, 'Has real results';
    isa_ok $res->[0], $model;
    note explain $res if $debug;
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
    basic_results_for_model( 'Compras::Model::TradingFloors', $data );
};

subtest 'Testing model IRPS' => sub {
    my $ua   = build_ua( module => 'licitacoes', method => 'irps', params => { uasg => 153229 } );
    my $data = $ua->get_data;
    basic_results_for_model( 'Compras::Model::IRPS', $data );
};

done_testing;

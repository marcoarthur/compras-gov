use strict;
use Test::More;
use Mojo::Base -signatures;
our $debug  = 1;
our $TARGET = { 'Compras::Model::NoPublicBidding' => 1, };

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

sub is_target( $model ) {
    return defined $TARGET->{$model};
}

sub get_model_args {
    return (
        'Compras::Model::TradingFloors' => { module => 'pregoes', params => { co_uasg => 254448 } },
        'Compras::Model::IRPS'          =>
          { module => 'licitacoes', method => 'irps', params => { uasg => 153229 } },
        'Compras::Model::Materials'       => { module => 'materiais', params => { grupo => 88 } },
        'Compras::Model::Services'        => { module => 'servicos',  params => { grupo => 542 } },
        'Compras::Model::NoPublicBidding' => {
            module => 'compraSemLicitacao',
            method => 'compras_slicitacao',
            params => { dt_publicacao => '20190701' }
        },
    );
}

subtest 'Testing model Institution' => sub {
    plan skip_all => 'not target' unless is_target('Compras::Model::Institutions');
    my $ua =
      build_ua( module => 'licitacoes', method => 'orgaos', params => { nome => 'turismo' } );
    my $url = $ua->url;
    is $url, 'http://compras.dados.gov.br/licitacoes/v1/orgaos.json?nome=turismo',
      "Url creation ok";

    basic_results_for_model('Compras::Model::Institutions');
};

subtest 'Testing Definition Models' => sub {
    my $ua = build_ua(
        module  => 'materiais',
        method  => 'material',
        params  => { id => 17663 },
        req_def => 1
    );
    my $data = $ua->get_data;
    ok $data->{results}, "has a result";
    ok $data->{results}->{descricao}, "has de description";
    note explain $data->{results} if $debug;
};

my %models = get_model_args;
for my $model ( keys %models ) {
    subtest "Testing model $model" => sub {
        plan skip_all => "$model not target" unless is_target($model);
        my $ua   = build_ua( $models{$model} );
        my $data = $ua->get_data;
        basic_results_for_model( $model, $data );
        note explain $data if $debug;
    };
}

done_testing;

#!/usr/bin/env perl 

use Mojo::Base -signatures;
use Syntax::Keyword::Try;
use Mojo::Collection;
use Text::CSV qw( csv );
use lib qw(./lib);

binmode( STDOUT, ":encoding(UTF-8)" );
use Compras::UA;

our @ATTRS = qw(
  cep cnpj ddd endereco fax id id_municipio id_orgao nome nome_mnemonico ramal
  ramal2 sigla_uf telefone telefone2 total_fornecedores_cadastrados total
  fornecedores_recadastrados unidade_cadastradora
);

sub usage {
    warn <<'EOM';
    ./scripts/search_uasgs.pl id [id ...] > /tmp/out.csv

    Searches UASGs records ( http://compras.dados.gov.br/docs/licitacoes/uasg.html )
    by id, and output a csv file with records found to stdout
EOM
    exit 1;
}

sub main {
    my @ids = @_;
    usage unless @ids;

    my $uas = Mojo::Collection->new(
        map {
            Compras::UA->new(
                module  => 'licitacoes',
                method  => 'uasg',
                params  => { id => $_ },
                req_def => 1,
            )
        } @ids
    );

    my $results = $uas->map( sub ($ua) { $ua->get_data } )->map(
        sub ($data) {
            [ map { $data->{results}->{$_} } @ATTRS ]
        }
    );

    unshift @$results, \@ATTRS;

    csv( in => $results->to_array, out => \*STDOUT );
    exit 0;
}

MAIN:
main(@ARGV);

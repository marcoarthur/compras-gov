#!/usr/bin/env perl 

use Mojo::Base -signatures;
use Syntax::Keyword::Try;
use Mojo::Collection;
use Text::CSV qw( csv );
use lib qw(./lib);
use Getopt::Long;

binmode( STDOUT, ":encoding(UTF-8)" );
use Compras::UA;

our %ATTRS = (
    licitacoes => { 
    uasg => [
        qw(
          cep cnpj ddd endereco fax id id_municipio id_orgao nome nome_mnemonico
          ramal ramal2 sigla_uf telefone telefone2
          total_fornecedores_cadastrados total fornecedores_recadastrados
          unidade_cadastradora
          )
    ],
    modalidade_licitacao => [qw( codigo descricao )],
    },
    contratos => {
        tipo_contrato => [ qw( codigo descricao ) ],
    }
);

our $module;
our $method;

sub usage {
    my $err = shift;

    warn "Error $err" if $err;
    warn <<'EOM';
    ./scripts/search_method.pl --module module --method meth id [id ...] > /tmp/out.csv

    Mandatory Args:
    --method : the method of the module 'licitacoes' we are requiring records.

    Searches Any method records (
http://compras.dados.gov.br/docs/licitacoes/uasg.html ) for 'licitacoes'
module by id outputs a csv file with any records found to stdout
EOM
    exit 1;
}

sub main {
    my @ids = @_;
    usage unless @ids;
    usage unless $method or $module;
    usage( "incorrect module or method\n" ) unless $ATTRS{$module}->{$method};

    my $uas = Mojo::Collection->new(
        map {
            Compras::UA->new(
                module  => $module,
                method  => $method,
                params  => { id => $_ },
                req_def => 1,
            )
        } @ids
    );


    my $results = $uas->map( sub ($ua) { $ua->get_data } )->map(
        sub ($data) {
            [ map { $data->{results}->{$_} } @{$ATTRS{$module}->{$method}} ]
        }
    );

    unshift @$results, $ATTRS{$module}->{$method};

    csv( in => $results->to_array, out => \*STDOUT );
    exit 0;
}

MAIN:
GetOptions( "method=s" => \$method, "module=s" => \$module ) or usage($!);
main(@ARGV);

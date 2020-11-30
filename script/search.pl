#!/usr/bin/env perl
use 5.028;
use Mojo::Base -signatures;
use Mojo::Log;
use Syntax::Keyword::Try;
use lib qw(./lib);
use utf8;
use Compras::Search;
use Text::CSV qw( csv );
use Safe::Isa;
use DDP;

binmode( STDOUT, ":encoding(UTF-8)" );
my $log = Mojo::Log->new;

sub write_csv( $data ) {
    my $res = $data->{results}->flatten or die "No results";
    my @lines;
    $res->each( sub { push @lines, $_->to_arrayref } );
    $_ = $res->[0];
    unshift @lines, $_->attributes_order if $_->$_isa('Compras::Model');
    die "No results" unless scalar @lines;
    csv( in => \@lines, out => \*STDOUT );
}

my $default_cb = sub ( $data ) {
    write_csv($data);
    return $data;
};

my @searches = (

    # all providers from Ubatuba city ( id 72095 )
    {
        description => 'all providers from Ubatuba city ( id 72095 )',
        search      => {
            module => 'fornecedores',
            params => { id_municipio => 72095 }
        },
        cb  => $default_cb,
        run => 0,
    },

    # bids from provider (id 538083)
    {
        description => 'bids from provider (id 538083)',
        search      => {
            module => 'licitacoes',
            params => { id_fornecedor => 538083 }
        },
        cb  => $default_cb,
        run => 0,

    },

    # find bids from ubatuba providers
    {
        description => 'bids from Ubatuba-SP providers',
        search      => {
            module => 'fornecedores',
            params => { id_municipio => 72095 }
        },
        cb => $default_cb,
        run => 0,
    },

    # find gov contracts involving personal contractors
    {
        description => 'contracts involving personal contractors',
        search      => {
            module => 'contratos',
            params => { tipo_pessoa => 'PF' }
        },
        cb  => $default_cb,
        run => 0,

    },

    # find gov contracts involving no licitation of contractors during 2020 up to 50.000
    {
        description => 'no licitation contracts during 2020 and value up to 50.000 BRL',
        search      => {
            module => 'contratos',
            params => {
                modalidade               => 6,
                data_inicio_vigencia_min => '2020-01-01',
                valor_inicial_min        => 50000
            }
        },
        cb  => $default_cb,
        run => 0,

    },

    # find gov contracts during 2020 up to 100.000
    {
        description => 'contracts during 2020,  value up to 100.000 BRL',
        search      => {
            module => 'contratos',
            params => {
                data_inicio_vigencia_min => '2020-01-01',
                valor_inicial_min        => 2 * 50000
            }
        },
        cb  => $default_cb,
        run => 0,

    },

    # find uasg descriptions
    {
        description => 'find uasg description',
        search      => {
            module  => 'licitacoes',
            method  => 'uasg',
            params  => { id => 200015 },
            req_def => 1,
        },
        cb => sub ($data) { p $data; return $data },
    }
);

sub do_search {
    my %values = @_;
    $log->info("Searching $values{description} ...");
    my $s = Compras::Search->new( query => $values{search}, tout => 380 );
    return $values{cb}->( $s->search );
}

sub run_all {
    my $index = $ARGV[0];

    if ( defined $index ) {
        my $search = $searches[$index];
        unless ($search) {
            $log->info(
                "Can't find search data (index: $index) select 0 up to $#searches, options are");
            for my $i ( 0 .. $#searches ) {
                $log->info("$i : $searches[$i]->{description}");
            }
            exit 1;
        }
        do_search(%$search);
        exit 0;
    }

    for my $search (@searches) {
        do_search(%$search);
    }
}

MAIN:
run_all;

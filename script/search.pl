#!perl
use 5.028;
use Mojo::Base -signatures;
use lib qw(./lib);
use utf8;
use Compras::UA;
use DDP;

my @searches = (

    # all providers from Ubatuba city ( id 72095 )
    {
        description => 'all providers from Ubatuba city ( id 72095 )',
        search      => {
            module => 'fornecedores',
            params => { id_municipio => 72095 }
        },
        cb  => sub ( $data ) {
		$data->{results}->each( sub{ p $_ } );
		return $data
	},
        run => 0,
    },

    # bids from provider (id 538083)
    {
        description => 'bids from provider (id 538083)',
        search      => {
            module => 'licitacoes',
            params => { id_fornecedor => 538083 }
        },
        cb  => sub ( $data ) { p $data; return $data },
        run => 0,

    },

    # find bids from ubatuba providers
    {
        description => 'bids from ubatuba providers',
        search      => {
            module => 'fornecedores',
            params => { id_municipio => 72095 }
        },
        cb => sub ( $data ) {
            my @providers_id = map { $_->{id} } @{ $data->{_embedded}->{fornecedores} };
            my @uas          = map {
                Compras::UA->new( { module => 'licitacoes', params => { id_fornecedor => $_ } } )
            } @providers_id;

            p $_->get_data for @uas;
        },
        run => 0,
    },
    # find gov contracts involving personal contractors
    {
        description => 'Pesquisar contratos',
        search      => {
            module => 'contratos',
            params => { tipo_pessoa => 'PF' }
        },
        cb  => sub ( $data ) { $data->{results}->each( sub{ p $_ } ); return $data },
        run => 0,

    },
    # find gov contracts involving personal contractors
    {
        description => 'Pesquisar contratos',
        search      => {
            module => 'contratos',
            params => { modalidade => 6, data_inicio_vigencia_min => '2020-01-01',  valor_inicial_min => 50000 }
        },
        cb  => sub ( $data ) { $data->{results}->each( sub{ p $_ } ); return $data },
        run => 1,

    },
);

sub do_search {
    my %values = @_;
    my $ua     = Compras::UA->new( %{ $values{search} } );
    return $values{cb}->( $ua->get_data );
}

sub run_all {
    for my $search (@searches) {
        next unless $search->{run};
        do_search(%$search);
    }
}

MAIN:
run_all;


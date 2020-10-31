#!perl
use 5.028;
use lib qw(./lib);
use utf8;
use Compras::UA;
use DDP;

my @searches = (
	# all providers from Ubatuba city ( id 72095 )
	#{ module => 'fornecedores', params => { id_municipio => 72095 } },
	# bids from provider (id 538083)
	{ module => 'licitacoes', params => { id_fornecedor => 538083 } },
);

sub do_search {
	my %values = @_;
	my $ua = Compras::UA->new(%values);
	return { url => $ua->url, results => $ua->get_data };
}

p $_ for map { do_search( %$_ ) } @searches;

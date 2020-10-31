#!perl
use 5.028;
use lib qw(./lib);
use utf8;
use Compras::UA;
use DDP;

my @searches = (
	{ module => 'fornecedores', params => { municipio => 72095 } }, # crashing
	{ module => 'contratos', params => {} },
);

sub do_search {
	my %values = @_;
	my $ua = Compras::UA->new(%values);
	return { url => $ua->url, results => $ua->get_data };
}

p $_ for map { do_search( %$_ ) } @searches;

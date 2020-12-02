use strict;
use warnings;

use Test::More;
use_ok $_ for qw( Compras::Search );

my $searches = [
    { module => 'servicos',  params => { grupo => 542 } },
    { module => 'materiais', method => 'material', params => { id => 17663 } },
    { module => 'licitacoes', method => 'uasgs', params => { nome => 'oswaldo cruz' } },
];

my $s = Compras::Search->new;
my @c;
for ( @$searches ) { 
    my $c = $s->query($_)->search->{results}->with_roles('Compras::JoinRole');
    push @c, $c;
}

map { ok $_->does('Compras::JoinRole'), "Does Join Role" } @c;
map { can_ok $_, qw(join_model) } @c;

my ($c1, undef, $c2) = @c;
my $m = $c1->join_model($c2, sub { 1 } ); # cross join
ok $m->size == ($c1->size * $c2->size), "Size is |A|x|B| == " . $m->size;
note explain $m->[0]->attributes;


done_testing;

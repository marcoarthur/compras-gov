use strict;
use warnings;

use Test::More;

my @searches = (
    { module => 'servicos', params => { grupo => 542 } },
    { module => 'materiais', method => 'material', params => { id => 17663 }, model => 0 },
);
use_ok $_ for qw( Compras::Search );

my $s = Compras::Search->new;
can_ok $s, qw(search);

my $res;

map { 
    $res = $s->query($_)->search;
    ok $res, "got a response";
    isa_ok $res->{results}, 'Mojo::Collection';
} @searches;

# apply roles to the models returned
$s->roles([ 'Compras::Model::Roles::ExpandLinks' ]);
$res = $s->query($searches[1])->search;
ok $res, "Has a new response";

done_testing;

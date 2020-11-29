use strict;
use warnings;

use Test::More;

my @searches = (
    { module => 'servicos', params => { grupo => 542 } },
    { module => 'materiais', method => 'material', params => { id => 17663 }, model => 0 },
);
use_ok $_ for qw( Compras::Search );

my $s = Compras::Search->new;
can_ok $s, qw(query);

my $res;

map { 
    $res = $s->query($_);
    ok $res, "got a response";
} @searches;

# apply roles to the models returned
$s->roles([ 'Compras::Model::Roles::ExpandLinks' ]);
$res = $s->query( $searches[0] );
ok $res, "Has a new response";

done_testing;

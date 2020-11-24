use strict;
use warnings;

use Test::More;

use_ok $_ for qw( Compras::Search );

my $s = Compras::Search->new;
my $res;

#$res = $s->query( { module => 'servicos', params => { grupo => 542 } } );
#note explain $res;

# apply roles to the models returned
$s->roles([ 'Compras::Model::Roles::ExpandLinks' ]);
$res = $s->query( { module => 'servicos', params => { grupo => 542 } } );
note explain $res;

#$res = $s->query(
#    { module => 'materiais', method => 'material', params => { id => 17663 }, req_def => 1 } );
#note explain $res;

done_testing;

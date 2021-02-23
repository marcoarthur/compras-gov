use strictures 2;
use Test::More;
use Mojo::Base -signatures;
use DDP;

use_ok $_ for qw( Compras::Model );

my $attributes = {
    a => 'this is a',
    b => 'this is b',
};

my $attr_values = { a => 'value a', b => 'value b' };
my $model;
ok $model =
  Compras::Model->new( attributes => $attributes )->from_hash( { a => 'value a', b => 'value b' } ),
  "Create an set";

is $model->$_, $attr_values->{$_}, "Ok value" for keys %$attr_values;

SKIP: {
    skip "this feature is under review", 1;

    #rerun from_hash make a no op
    $model->from_hash( { a => 'new a', b => 'new b' } );
    is_deeply $model->to_hash, $attr_values, "Rerun from_hash is no op";
}

# model with callback set for `attr_set' event
my $new_attrs = { c => 'this is c', d => 'this is d' };
$model = Compras::Model->new( attributes => $new_attrs );
$model->on(

    # callback uppercases values passed
    attr_set => sub ( $self, $attr ) {
        my $attr_name = $attr->{name};
        $self->$attr_name( uc $attr->{value} );    # capitalize it
    }
);

# populated model with values
$model->from_hash( { c => 'value c', d => 'value d' } );

is_deeply $model->to_hash, { c => 'VALUE C', d => 'VALUE D' },
  "Ok Trigger Event for model data population";

done_testing;

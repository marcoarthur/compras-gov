package Compras::JoinRole;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Compras::Model;
use Safe::Isa;
use Clone qw(clone);
requires qw(each);

# collections are assumed to hold Compras::Model's
# $on is a coderef that accepts two models
# returning true/false.
sub join_model ( $self, $coll, $on ) {
    raise "Compras::Exception", "Not a collection"    unless $coll->$_isa('Mojo::Collection');
    raise "Compras::Exception", "Not a join function" unless ref $on eq 'CODE';

    my $res     = Mojo::Collection->new;
    my $results = $self->each(
        sub ( $a, $a_index ) {
            $coll->each(
                sub ( $b, $b_index ) {
                    if ( $on->( $a, $b ) ) {
                        push @$res, $self->_merge_model( $a, $b );
                    }
                }
            );
        }
    );

    return $res;
}

# merge two models into one. This operation creates a new Compras::Model
sub _merge_model ( $self, $x, $y ) {
    my $x_attrs = clone $x->to_hash;
    my $y_attrs = clone $y->to_hash;
    my $x_attrs_table = clone $x->attributes;
    my $y_attrs_table = clone $y->attributes;

    # check collisions
    my @xcols      = keys %$x_attrs_table;
    my @collisions = grep { defined $_ } @$y_attrs_table{@xcols};

    if (@collisions) {
        raise "Compras::Exception", "Collision for column(s) : @collisions";
    }

    # merged attributes
    @$x_attrs_table{ keys %$y_attrs_table } = values %$y_attrs_table;
    @$x_attrs{ keys %$y_attrs } = values %$y_attrs;

    my $joined = Compras::Model->new( attributes => $x_attrs_table )->from_hash($x_attrs);
    return $joined;
}

1;

package Compras::Utils;
use strictures 2;
use Mojo::Loader qw(load_class find_modules);
use Mojo::Exception qw(raise);
use Mojo::Collection;
use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = (qw(&load_models));

sub load_models {
    my $namespace = 'Compras::Model';
    my @models;
    for my $model ( find_modules $namespace ) {
        my $e = load_class $model;
        raise "Compras::Exception", "Error($e) loading model $model" if $e;
        push @models, $model;
    }

    return Mojo::Collection->new(@models);
}

1;

package Compras::Utils;
use strictures 2;
use Mojo::Loader qw(load_class find_modules);
use Mojo::Exception qw(raise);
use Mojo::Collection;
use List::Util qw(first);
use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = (qw(&load_models &module_method_list &determine_model_from_url));

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

sub module_method_list {
    my $models       = load_models;
    my $modules_list = {};
    $models->each(
        sub {
            my $class  = shift;
            my $obj    = $class->new;                      # create model
            my $module = $obj->from_module;                # get its module
            my $table  = $modules_list->{$module} || {};
            $table->{ $obj->model_name } = $class;
            $modules_list->{$module} = $table;
        }
    );
    return $modules_list;
}

sub determine_model_from_url {
    my $url = Mojo::URL->new(shift);
    my ( $module, $method );
    my $parts       = $url->path->parts;
    my $module_list = module_method_list;

    # v1 or doc in path: check extract module method
    if ( first { $_ eq "v1" or $_ eq "doc" or $_ eq "id" } @$parts ) {
        ( $module, undef, $method ) = @$parts;
        $method =~ s/_+//g;
        $method =~ s/\.json$//;
        my $model = $module_list->{$module}->{$method};

        unless ($model) {
            warn "Model not found for $module $method";
            return;
        }

        return $model->new;
    }

    die "Can't say which model from $url";
}

1;

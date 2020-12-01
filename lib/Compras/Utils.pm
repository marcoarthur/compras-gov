package Compras::Utils;
use strictures 2;
use Mojo::Loader qw(load_class find_modules);
use Mojo::Exception qw(raise);
use Mojo::Collection;
use List::Util qw(first);
use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = (qw(&load_models &module_method_list &determine_model_from_url &model_from_query));

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

sub model_from_query {

    # search using module / method parameters
    my $query = shift;
    my ( $module, $method ) = @$query{qw(module method)};
    my @models = @{ load_models->map( sub { $_->new } )->to_array };
    my @found  = grep { $_->from_module eq $module && $_->model_name eq $method } @models;

    return unless @found;

    # verify further parameters for disambiguation
    if ( @found > 1 ) {
        if ( $query->{submethod} ) {
            return first { $_->can('submethod') && $_->submethod eq $query->{submethod} } @found;
        }
    }

    return $found[0];
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

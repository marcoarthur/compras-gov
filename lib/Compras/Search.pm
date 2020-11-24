package Compras::Search;
use Mojo::Base -base, -signatures;
use Syntax::Keyword::Try;
use Mojo::Exception qw(raise);
use Mojo::Redis;
use Compras::UA;
use Mojo::JSON qw(encode_json decode_json);
use Safe::Isa;
use Mojo::Log;
use Mojo::Loader qw(find_modules);
use List::Util qw(first);
use Digest::MD5 qw(md5_hex);
our $HIST = {};

has cache => sub { state $redis = Mojo::Redis->new->db };
has log   => sub { state $log   = Mojo::Log->new };
has roles => sub { [] };

sub key ( $self, $q ) {

    # combine query url and roles
    my $joined = join "|", ( $q, @{ $self->roles } );
    md5_hex($joined);
}

sub query ( $self, $q ) {
    my $ua  = Compras::UA->new($q);
    my $key = $self->key( $ua->url );
    my $res = $self->cache->get($key);
    return decode_json($res) if $res;

    $self->log->info("Fetching from server");
    try {
        $res = $ua->get_data->{results};

        # model collection: apply any role and transform in hash
        if ( $res->$_isa('Mojo::Collection') ) {
            $self->_apply_role($res);
            my $arr = $res->map(
                sub {
                    $_->add_to_attrs( '_other', "Extra attribute" );
                    $_->to_hash;
                }
            )->to_array;
            $res = $arr;
        }

        $self->cache->set( $key, encode_json($res) );
    } catch ($e) {
        my $url = $ua->url;
        raise 'Compras::Exception', "Error querying $url: $e";
    }

    return $res;
}

sub _apply_role ( $self, $collection ) {
    return unless @{ $self->roles } > 0;
    my @all = find_modules 'Compras::Model::Roles';

    for my $role ( @{ $self->roles } ) {
        my $m = first { $_ eq $role } @all;
        raise 'Compras::Exception', "Role $role Not found" unless $m;
        $collection->each(
            sub {
                $_->with_roles($role);
                if ( $role =~ /ExpandLinks/ ) {
                    $_->log( $self->log )->expand_links;
                }
                if ( $role =~ /ExtendedAttrs/ ) {
                    $_->install_acessors_from_links;
                }
            }
        );
    }

}

1;

__END__

=encoding utf8

=head1 NAME

Compras::Search - Search interface to Compras::UA

=head1 SYNOPSIS

Interface handling cache to Compras::UA. Making less stressful for the server.
It depends on Redis database. It can be configured under ~/.compras/redis.conf

=head1 DESCRIPTION

A module to search and cache results of search. It depends on C<Mojo::Redis> as
cache object. It can be configured using configure file.

=head1 ATTRIBUTES

=head2 cache

A Mojo::Redis handler.

=head2 log

A Logger Object default Mojo::Log

=head2 roles

A hash reference containing Roles to apply to basic Compras::Model.

=head1 METHODS

=head2 key($query)

Calculate the key of query. Based on query and Roles

=head2 query($hashref)

  $self->query( { module => licitacoes, params => { valor_inicial_min => 1000 } } )

Execute the query caching it. It will rerun the query on server given if query
had expired.

=head1 AUTHOR

Marco Arthur,,,

=head1 COPYRIGHT AND LICENSE


This is Free Software, Licensed under Perl License.

=head1 SEE ALSO

Compras::UA

=cut

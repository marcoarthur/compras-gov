package Compras::Model::Roles::ExpandLinks;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Mojo::URL;
use Mojo::UserAgent;

has base_url => sub { Mojo::URL->new('http://compras.dados.gov.br') };
has _ua      => sub { Mojo::UserAgent->new };
has log      => sub { die "Requires a logger" };
has links    => sub {
    my $self = shift;
    my $links = $self->_other->{_links};
    return Mojo::Collection->new( @$links{ $self->_topics } )->each(
        sub ( $e, $n ) {
            my $url = Mojo::URL->new( $e->{href} )->base( $self->base_url );
            $url->path->parts->[-1] .= '.json';    # append format
            $e->{href} = $url->to_abs;             # update href
        }
    );
};

has accessor => sub { 'expanded_data' };

# Get from _links hash references containing an href key
sub _topics( $self ) {
    my $links = $self->_other->{_links};

    my @topics = grep {
        $_ !~ /self|first/ &&                      # not an autolink
          ref $links->{$_} eq 'HASH' &&            # expandable
          exists $links->{$_}->{href}              # has link to follow
    } keys %$links;

    return @topics;
}

sub expand_links( $self ) {
    $self->log->info( "Expanding info for " . join " ", $self->_topics );
    $self->links->each(
        sub ( $e, $n ) {
            my $url = $e->{href};
            $self->log->info( "Following " . $url );
            my $res = $self->_ua->get( $url )->result;

            if ( $res->is_error ) {
                raise 'Compras::Exception', "Error fetching $url";
            } else {
                $self->log->info("Saving info");
                $e->{$self->accessor} = $res->json;
            }
        }
    );
}

1;

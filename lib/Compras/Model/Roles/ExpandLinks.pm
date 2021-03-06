package Compras::Model::Roles::ExpandLinks;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Mojo::URL;
use Mojo::UserAgent;
use Compras::RSet;
use Compras::Utils qw(determine_model_from_url);
use DDP;
use Syntax::Keyword::Try;

our $CACHE = {};

has log       => sub { die "Requires a logger" };
has hist      => sub { $CACHE };
has accessor  => sub { 'expanded_data' };
has _base_url => sub { Mojo::URL->new('http://compras.dados.gov.br') };
has _ua       => sub { Mojo::UserAgent->new->inactivity_timeout(60)->max_redirects(5) };
has _links    => sub {
    my $self  = shift;
    my $links = $self->_other->{_links};
    return Mojo::Collection->new( @$links{ $self->_topics } )->each(
        sub ( $e, $n ) {
            my $url = Mojo::URL->new( $e->{href} )->base( $self->_base_url );
            $url->path->parts->[-1] .= '.json';    # append format
            $e->{href} = $url->to_abs;             # update href
        }
    );
};

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
    $self->_links->each(
        sub ( $e, $n ) {
            my $url   = $e->{href};
            my $model = determine_model_from_url($url);
            unless ($model) {
                warn "Skipping $url could not determine a model";
                return;
            }

            if ( exists $self->hist->{$url} ) {
                $self->log->info( "From cache " . $url );
                my $cached = $self->hist->{$url};
                $e->{ $self->accessor } = $cached;
                return;
            }

            try {
                $self->log->info( "Following " . $url );
                my $tx = $self->_ua->get($url);
                $self->log->info("Saving info");
                my $r      = Compras::RSet->new( tx => $tx, );
                my $parsed = $r->parse($model);
                $self->hist->{$url} = $parsed;
                $e->{ $self->accessor } = $self->hist->{$url};
            } catch ($err) {
                warn "Unable to retrieve $url and save: $err";
                return;
            }
        }
    );
}

1;

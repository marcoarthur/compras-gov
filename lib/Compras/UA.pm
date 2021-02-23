package Compras::UA;
use 5.028;
use Mojo::Base -base, -signatures, -async_await;
use Mojo::Template;
use Mojo::UserAgent;
use Mojo::Log;
use Compras::RSet;
use Mojo::Exception qw(raise);
our $VERSION = "0.05";
use constant TIMEOUT     => 120;
use constant MAX_RECORDS => 500;

has log_level => sub { 'debug' };

has model => sub { die "Required model for search results" };
has tout  => sub { TIMEOUT };
has _hist => sub { +{} };
has _log  => sub { Mojo::Log->new( level => shift->log_level ) };
has _ua   => sub { Mojo::UserAgent->new->inactivity_timeout( shift->tout )->max_redirects(5) };

# non blocking
async sub get_data_p ( $self, $url ) {
    return $self->_ua->get_p($url);
}

# blocking
sub get_data ( $self, $url ) {
    my $cached = $self->_hist->{$url};
    return $cached if $cached;

    $self->_log->info("Getting data from $url");
    my ( $rs, $e, $res );

    $self->get_data_p($url)->then(
        sub ($tx) {
            $rs  = Compras::RSet->new(tx => $tx);
            $res = $rs->parse($self->model);
        }
    )->catch(
        sub ($err) {
            $self->_log->fatal("Error: $err with url: $url");
            $e = $err;
        }
    )->wait;

    if ($e) {
        raise "Compras::Exception", "Check your internet connection: $e";
        return;
    }

    # After the first request: check if we need more request to fullfill
    # records missing. Make concurrent calls to receive the rest of records.
    # (Serve response with maximum 500 records per request)
    my $total  = $res->{count} || 0;
    my $amount = $res->{results}->size;
    my @promises;
    my $remain = Mojo::URL->new($url);

    while ( $total > $amount ) {
        $remain->query->merge( offset => $amount );
        $self->increase_timeout(5);
        push @promises, $self->get_data_p($remain)->then(
            sub ($tx) {
                $rs->tx($tx);
                my $partial = $rs->parse($self->model)->{results};
                push @{ $res->{results} }, @{$partial};
                my $size = $partial->size;
                $self->_log->info("Retrivied $size records from $total total");
            }
        )->catch(
            sub ($err) {
                $self->_log->fatal( "Error: $err with url: " . $url );
            }
        );
        $amount += MAX_RECORDS;
    }

    # has records to resolve: fetch then all
    if (@promises) {
        Mojo::Promise->all_settled(@promises)->then(
            sub (@p) {
                $self->_log->info( "Total " . $res->{results}->size . " records retrieved" );
            }
        )->wait;
    } else {
        $self->_log->info( "Total " . $res->{results}->size . " records retrieved" );
    }

    # save in history
    $self->_hist->{$url} = $res;
    return $res;
}

sub increase_timeout ( $self, $inc ) {
    my $timeout = $self->tout;
    $self->tout( $timeout + $inc );
    $self->_ua->inactivity_timeout( $self->tout );
}

1;

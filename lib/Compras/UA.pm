package Compras::UA;
use 5.028;
use Mojo::Base -base, -signatures, -async_await;
use Mojo::Template;
use Mojo::UserAgent;
use Mojo::Log;
use Compras::RSet;
use Mojo::Exception qw(raise);
our $VERSION = "0.01";
use constant TIMEOUT     => 120;
use constant MAX_RECORDS => 500;

has base   => sub { 'http://compras.dados.gov.br' };
has module => sub { die "module is required" };
has method => sub { shift->module or die "method is required" };
has format => sub { 'json' };
has params => sub { +{} };
has _ua    => sub { Mojo::UserAgent->new->inactivity_timeout(TIMEOUT) };
has _templ => sub { Mojo::Template->new };
has _hist  => sub { +{} };
has _data  => sub {
    <<'EOT';
	% my $url = qq{$base/$module/v1/$method.$format};
	% my $params = join "&", map { qq($_=$params->{$_}) } keys %$params;
	% $url = $params ? join("?", $url, $params) : $url;
	<%= $url =%>
EOT
};

has _log => sub { Mojo::Log->new };

sub url( $self ) {
    return $self->_templ->vars(1)
      ->render( $self->_data, { map { $_ => $self->$_ } qw( base module method format params ) } );
}

# non blocking
async sub get_data_p( $self ) {
    return $self->_ua->get_p( $self->url );
}

# blocking
sub get_data( $self ) {
    my ( $res, $format, $url ) = ( undef, $self->format, $self->url );
    my $cached = $self->_hist->{$url};
    return $cached if $cached;

    $self->_log->info("Getting data from $url");
    my $rs;

    $self->get_data_p->then(
        sub ($tx) {
            $rs  = Compras::RSet->new( tx => $tx );
            $res = $rs->parse;
        }
    )->catch(
        sub ($err) {
            $self->_log->fatal("Error: $err with url: $url");
            raise "Compras::Exception", "Error $err , check internet connection";
        }
    )->wait;

    # After the first request: check if we need more request to fullfill
    # records missing. Make concurrent calls to receive the rest of records.
    # (Serve response with maximum 500 records per request)
    my $total  = $res->{count};
    my $amount = $res->{results}->size;
    my @promises;

    while ( $total > $amount ) {
        $self->params->{offset} = $amount;
        my $url = $self->url;
        push @promises, $self->get_data_p->then(
            sub ($tx) {
                $rs->tx($tx);
                my $partial = $rs->parse->{results};
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
    }

    # save in history
    $self->_hist->{$url} = $res;
    return $res;
}

1;

__END__

=encoding utf-8

=head1 NAME

Compras::UA - It's new $module

=head1 SYNOPSIS

    use Compras::UA;

=head1 DESCRIPTION

Compras::UA is ...

=head1 LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=cut

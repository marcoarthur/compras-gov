package Compras::UA;
use 5.028;
use Mojo::Base -base, -signatures, -async_await;
use Mojo::Template;
use Mojo::UserAgent;
use Mojo::Log;
use Compras::RSet;
our $VERSION = "0.01";
use constant TIMEOUT => 180;

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

async sub get_data_p( $self ) {
    return $self->_ua->get_p( $self->url );
}

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
        }
    )->wait;

    my $total = $res->{count};

  RETRIEVE:
    my $amount = $res->{results}->size;
    if ( $total > $amount ) {
        $self->_log->info("Retrivied $amount records from $total total");
        $self->params->{offset} = $amount;
        $self->get_data_p->then(
            sub ($tx) {
                $rs = Compras::RSet->new( tx => $tx );
                push @{ $res->{results} }, @{ $rs->parse->{results} };
            }
        )->catch(
            sub ($err) {
                $self->_log->fatal("Error: $err with url: $url");
            }
        )->wait;
    }
    goto RETRIEVE if $total > $res->{results}->size;

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

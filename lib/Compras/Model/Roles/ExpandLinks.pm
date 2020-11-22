package Compras::Model::Roles::ExpandLinks;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Mojo::URL;
use Mojo::UserAgent;

has base_url => sub { Mojo::URL->new('http://compras.dados.gov.br') };
has _ua      => sub { Mojo::UserAgent->new };

sub expand_links( $self ) {
    my $links = $self->_other->{_links};

    for my $l ( keys %$links ) {
        next if $l eq "self" or $l eq "first";    # auto link, ignores
        my $link = $links->{$l};
        next unless ref $link eq 'HASH';          # no-expandable field
        next unless $link->{href};                # no link to follow
        my $path = $link->{href};
        my $url  = Mojo::URL->new($path)->base( $self->base_url );
        $url->path->parts->[-1] .= '.json';       # append format

        # blocking fetch
        my $res = $self->_ua->get( $url->to_abs )->result;

        if ( $res->is_success ) {
            $links->{$l}->{expanded_data} = $res->json;
        } elsif ( $res->is_error ) {
            raise 'Compras::Exception', "Error fetching $url";
        }
    }
}

1;

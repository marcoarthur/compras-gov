#!/usr/bin/env perl
use 5.028;
use Mojo::Base -signatures;
use Mojo::Log;
use Syntax::Keyword::Try;
use lib qw(./lib);
use utf8;
use Compras::Search;
use Text::CSV qw( csv );
use Safe::Isa;
use DDP;

binmode( STDOUT, ":encoding(UTF-8)" );
my $log = Mojo::Log->new;

sub write_csv( $data ) {
    my $res = $data->{results}->flatten or die "No results";
    my @lines;
    $res->each( sub { push @lines, $_->to_arrayref } );
    $_ = $res->[0];
    unshift @lines, $_->attributes_order if $_->$_isa('Compras::Model');
    die "No results" unless scalar @lines;
    csv( in => \@lines, out => \*STDOUT );
}

my $default_cb = sub ( $data ) {
    write_csv($data);
    return $data;
};

my %cbs = (
    default_cb => $default_cb
);

my $data = require './script/data/searches.conf';
my @searches = @$data;

sub do_search {
    my %values = @_;
    $log->info("Searching $values{description} ...");
    my $s = Compras::Search->new( query => $values{search} );
    return $values{cb}->( $s->search ) if ref $values{cb};
    return $cbs{ $values{cb} }->( $s->search );
}

sub run_all {
    my $index = $ARGV[0];

    if ( defined $index ) {
        my $search = $searches[$index];
        unless ($search) {
            $log->info(
                "Can't find search data (index: $index) select 0 up to $#searches, options are");
            for my $i ( 0 .. $#searches ) {
                $log->info("$i : $searches[$i]{description}");
            }
            exit 1;
        }
        do_search(%$search);
        exit 0;
    }

    for my $search (@searches) {
        do_search(%$search);
    }
}

MAIN:
run_all;

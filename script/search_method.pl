#!/usr/bin/env perl 

use Mojo::Base -signatures;
use Syntax::Keyword::Try;
use Mojo::Collection;
use Text::CSV qw( csv );
use lib qw(./lib);
use Getopt::Long;

binmode( STDOUT, ":encoding(UTF-8)" );
use Compras::Search;


our $module;
our $method;
our $params;

sub usage {
    my $err = shift;

    warn "Error $err" if $err;
    warn <<'EOM';
    ./scripts/search_method.pl --module module --method meth id [id ...] > /tmp/out.csv

    Mandatory Args:
    --method : the method of the module 'licitacoes' we are requiring records.

    Searches Any method records (
http://compras.dados.gov.br/docs/licitacoes/uasg.html ) for 'licitacoes'
module by id outputs a csv file with any records found to stdout
EOM
    exit 1;
}

sub write_csv( $data ) {
    my $res = $data->{results}->flatten or die "No results";
    my @lines;
    $res->each( sub { push @lines, $_->to_arrayref } );
    unshift @lines, $res->[0]->attributes_order;
    die "No results" unless scalar @lines;
    csv( in => \@lines, out => \*STDOUT );
}

sub main {
    usage unless $module;
    $method //= $module;
    ## no critic
    $params = eval "$params" if $params;
    ## critic
    
    my $s = Compras::Search->new(
        query => { 
            module  => $module,
            method  => $method,
            params  => $params,
        }
    );


    write_csv($s->search);
    exit 0;
}

MAIN:
GetOptions( "method=s" => \$method, "module=s" => \$module, "params=s" => \$params ) or usage($!);
main(@ARGV);

package Compras::Model::Roles::Serialize;
use Mojo::Base -base, -signatures, -role;
use Mojo::Exception qw(raise);
use Syntax::Keyword::Try;
use Mojo::JSON qw(encode_json);
use YAML;
requires qw(to_hash attributes);

has fh => sub { \*STDOUT };

sub to_json($self) {
    $self->attributes->{_other} = 'Atributo extra do modelo';
    my $href = $self->to_hash;

    try { 
        print { $self->fh } encode_json($href);
    } catch( $e ) {
        raise "Compras::Exception", "Error $e while encoding to json";
    }
}

sub to_yaml($self) {
    $self->attributes->{_other} = 'Atributo extra do modelo';
    my $href = $self->to_hash;

    try { 
        print { $self->fh } Dump($href);
    } catch( $e ) {
        raise "Compras::Exception", "Error $e while encoding to yaml";
    }
}

1;

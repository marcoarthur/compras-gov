package Compras::Model::MaterialGroup;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/grupo.html' };
has from_module => sub { return 'materiais' };
has model_name  => sub { return 'grupo' };
has attributes  => sub {
    return {
        codigo    => 'Código do grupo do material.',
        descricao => 'Descrição do grupo do material.',
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Código do grupo do material.' ], };
};

has template => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}.$format} );
	<%== $url->to_abs =%>
EOT
};

has json_res_structure => sub {
    return {
        'links' => '/_links',
        map { $_ => "/$_" } keys %{ shift->attributes }
    };
};

1;

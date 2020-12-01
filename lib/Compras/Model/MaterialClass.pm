package Compras::Model::MaterialClass;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/classe.html' };
has from_module => sub { return 'materiais' };
has model_name  => sub { return 'classe' };
has attributes  => sub {
    return {
        codigo       => 'Código da classe do material.',
        codigo_grupo => 'Código do grupo ao qual pertence à classe',
        descricao    => 'Descrição da classe do material.',
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Código da classe do material.' ], };
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

package Compras::Model::Material;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/material.html' };
has from_module => sub { return 'materiais' };
has model_name  => sub { return 'material' };
has attributes  => sub {
    return {
        codigo      => 'Código do item de material.',
        descricao   => 'Descrição do material.',
        id_classe   => 'Código da classe de material.',
        id_grupo    => 'Código do grupo de material',
        id_pdm      => 'Código do padrão descritivo de material.',
        status      => 'Indicador se o item é ou não ativo.',
        sustentavel => 'Indicador se o item é ou não sustentável.',
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Código do material.' ], };
};

has template => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/id/material/$params->{id}.$format} );
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

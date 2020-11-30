package Compras::Model::MaterialPdm;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/pdm.html' };
has from_module => sub { return 'materiais' };
has model_name  => sub { return 'pdm' };
has attributes  => sub {
    return {
        codigo        => 'Código do padrão descritivo de material.',
        codigo_classe => 'Código da classe à qual está associado o PDM.',
        descricao     => 'Descrição do padrão descritivo de material.',
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Código do PDM.' ], };
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

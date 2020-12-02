package Compras::Model::ProvidersPF;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub { return 'http://compras.dados.gov.br/docs/fornecedores/fornecedor_pf.html' };
has from_module => sub { return 'fornecedores' };
has model_name  => sub { return 'fornecedor_pf' };
has template => sub {
    return <<'EOT';
    % use Mojo::URL;
    % my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}.$format} );
    <%= $url->to_abs =%>
EOT
};
has attributes  => sub {
    return {
        ativo                   => 'Se o fornecedor está ativo.',
        caixa_postal            => 'Caixa Postal do Fornecedor.',
        cpf                     => 'CPF do fornecedor.',
        habilitado_licitar      => 'Campo que indica se o fornecedor está habilitado a licitar.',
        id                      => 'Identificador único do fornecedor no SICAF.',
        id_municipio            => 'Identificador único de município no SICAF.',
        id_unidade_cadastradora => 'Identificador único da UASG.',
        nome                    => 'Nome do fornecedor.',
        recadastrado            => 'Se o fornecedor se recadastrou no Novo SICAF.',
        uf                      => 'Sigla da UF.',
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Id do Fornecedor.' ], };
};

has json_res_structure => sub {
    return {
        'links' => '/_links',
        map { $_ => "/$_" } keys %{ shift->attributes }
    };
};

1;

package Compras::Model::Providers;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
    return {
        ativo => 'Se o fornecedor está ativo.',
        cnpj  => 'CNPJ do fornecedor.',
        cpf   => 'CPF do fornecedor.',
        habilitado_licitar =>
          'Campo que indica se o fornecedor está habilitado a licitar.',
        id      => 'Identificador único do fornecedor no SICAF.',
        id_cnae => 'Identificador único do código CNAE do fornecedor.',
        id_cnae2 =>
          'Identificador único do código CNAE secundário fornecedor.',
        id_municipio         => 'Identificador único de município no SICAF.',
        id_natureza_juridica => 'Identificador único da natureza jurídica.',
        id_porte_empresa     => 'Identificador único do porte de empresa.',
        id_ramo_negocio      => 'Identificador único do ramo de negócio.',
        id_unidade_cadastradora =>
'Identificador único da Unidade Cadastradora à qual o fornecedor está cadastrado no SICAF.',
        nome         => 'Nome do fornecedor.',
        recadastrado => 'Se o fornecedor se recadastrou no Novo SICAF.',
        uf           => 'Sigla da UF.',
    };
};

1;

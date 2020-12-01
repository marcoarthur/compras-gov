package Compras::Model::Providers;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub { return 'http://compras.dados.gov.br/docs/fornecedores/v1/fornecedores.html' };
has from_module => sub { return 'fornecedores' };
has model_name  => sub { return 'fornecedores' };
has attributes  => sub {
    return {
        ativo                   => 'Se o fornecedor está ativo.',
        cnpj                    => 'CNPJ do fornecedor.',
        cpf                     => 'CPF do fornecedor.',
        habilitado_licitar      => 'Campo que indica se o fornecedor está habilitado a licitar.',
        id                      => 'Identificador único do fornecedor no SICAF.',
        id_cnae                 => 'Identificador único do código CNAE do fornecedor.',
        id_cnae2                => 'Identificador único do código CNAE secundário fornecedor.',
        id_municipio            => 'Identificador único de município no SICAF.',
        id_natureza_juridica    => 'Identificador único da natureza jurídica.',
        id_porte_empresa        => 'Identificador único do porte de empresa.',
        id_ramo_negocio         => 'Identificador único do ramo de negócio.',
        id_unidade_cadastradora =>
'Identificador único da Unidade Cadastradora à qual o fornecedor está cadastrado no SICAF.',
        nome         => 'Nome do fornecedor.',
        recadastrado => 'Se o fornecedor se recadastrou no Novo SICAF.',
        uf           => 'Sigla da UF.',
    };
};

has search_parameters => sub {
    return {
        ativo              => [ 'Booleano', 'Não', 'Se o fornecedor está ativo.' ],
        cnpj               => [ 'Texto',    'Não', 'CNPJ do fornecedor.' ],
        cpf                => [ 'Texto',    'Não', 'CPF do fornecedor.' ],
        habilitado_licitar => [ 'Booleano', 'Não', '' ],
        id_cnae => [ 'Inteiro', 'Não', 'Identificador único do código CNAE do fornecedor.' ],
        id_linha_fornecimento =>
          [ 'Inteiro', 'Não', 'Identificador único de linha de fornecimento do fornecedor.' ],
        id_municipio         => [ 'Inteiro', 'Não', 'Identificador único de município no SICAF.' ],
        id_natureza_juridica =>
          [ 'Inteiro', 'Não', 'Identificador único da natureza jurídica do fornecedor.' ],
        id_porte_empresa =>
          [ 'Inteiro', 'Não', 'Identificador único do tipo da empresa do fornecedor.' ],
        id_ramo_negocio =>
          [ 'Inteiro', 'Não', 'Identificador único do ramo de negócio do fornecedor.' ],
        id_unidade_cadastradora => [
            'Inteiro',
            'Não',
'Identificador único da Unidade Cadastradora à qual o fornecedor está cadastrado no SICAF.'
        ],
        nome   => [ 'Texto', 'Não', 'Parte do nome do fornecedor.' ],
        offset => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by     => [ 'Texto',    'Não', 'Atributo utilizado para ordenação' ],
        recadastrado => [ 'Booleano', 'Não', 'Se o fornecedor se recadastrou no Novo SICAF.' ],
        tipo_pessoa  => [ 'Texto',    'Não', 'Tipo da pessoa, física PF ou jurídica PJ.' ],
        uf           => [ 'Texto',    'Não', 'Sigla da Unidade Federativa.' ],
    };
};

1;

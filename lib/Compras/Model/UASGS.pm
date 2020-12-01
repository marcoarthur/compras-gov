package Compras::Model::UASGS;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/licitacoes/v1/uasgs.html' };
has from_module => sub { return 'licitacoes' };
has model_name  => sub { return 'uasgs' };
has attributes  => sub {
    return {
        ativo                            => 'Se a UASG está ativa.',
        cep                              => 'CEP da UASG.',
        cnpj                             => 'CNPJ da UASG',
        id                               => 'Identificador único da UASG no SICAF.',
        id_municipio                     => 'Identificador único do município da UASG.',
        id_orgao                         => 'Identificador único do órgão no SICAF.',
        nome                             => 'Nome da UASG.',
        total_fornecedores_cadastrados   => 'Quantidade total de fornecedores cadastrados na UASG.',
        total_fornecedores_recadastrados =>
          'Quantidade total de fornecedores recadastrados, no novo SICAF, na UASG.',
        unidade_cadastradora => 'Unidade cadastradora.',
    };
};

has search_parameters => sub {
    return {
        ativo        => [ 'Booleano', 'Não', 'Se a UASG está ativa.' ],
        cep          => [ 'Texto',    'Não', 'CEP da UASG.' ],
        cnpj         => [ 'Texto',    'Não', 'CNPJ da UASG.' ],
        id_municipio => [ 'Inteiro',  'Não', 'Identificador único de município no SICAF.' ],
        id_orgao     => [ 'Inteiro',  'Não', 'Órgão associado à UASG' ],
        nome         => [ 'Texto',    'Não', 'Parte do nome da UASG.' ],
        offset       => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by             => [ 'Texto',    'Não', 'Atributo que deve ser usado como ordenador' ],
        unidade_cadastradora => [ 'Booleano', 'Não', 'Unidade Cadastradora.' ],
    };
};

1;

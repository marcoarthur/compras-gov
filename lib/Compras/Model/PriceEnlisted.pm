package Compras::Model::PriceEnlisted;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/v1/precos_praticados.html';
};

has from_module => sub { return 'licitacoes' };
has model_name  => sub { return 'precos_praticados' };

has attributes => sub {
    return {
        id_licitacao => 'Identificador da Licitação',
        modalidade   => 'Código da modalidade de licitação.',
        numero_aviso => 'Número do aviso da licitação.',
        numero_itens => 'Número de Itens.',
        objeto       => 'Objeto da licitação.',
        situacao     => 'Situação da licitação.',
        uasg         => 'Código da UASG.',
        valor_total  => 'Valor Total.',
    };
};

has search_parameters => sub {
    return {
        modalidade   => [ 'Inteiro', 'Não', 'Código da modalidade da licitação.' ],
        numero_aviso => [ 'Inteiro', 'Não', 'Número da licitação.' ],
        objeto       => [ 'Texto',   'Não', 'Objeto da licitação.' ],
        offset       => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by          => [ 'Texto',   'Não', 'Atributo que deve ser usado como ordenador' ],
        pregao_eletronico => [ 'boolean', 'Não', 'Indica se o pregão é eletrônico ou não.' ],
        situacao          => [ 'Texto',   'Não', 'Situação da licitação.' ],
        uasg              => [ 'Inteiro', 'Não', 'Código da UASG.' ],
        uasg_municipio    => [ 'Inteiro', 'Não', 'Código do município da UASG' ],

    };
};

1;

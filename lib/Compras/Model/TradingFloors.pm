package Compras::Model::TradingFloors;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/pregoes/v1/pregoes.html' };
has from_module => sub { return 'pregoes' };
has attributes  => sub {
    return {
        co_portaria           => 'Informa código da portaria',
        co_processo           => 'Informa número do processo',
        co_uasg               => 'Número da UASG que registrou o aviso de licitação',
        ds_situacao_pregao    => 'Informação da situação do pregão',
        ds_tipo_pregao        => 'Tipo de pregão',
        ds_tipo_pregao_compra => 'Tipo de compra',
        dtDataEdital          => 'Informa data de disponibilização do edital',
        dtFimProposta         => 'Informa data de fim da proposta',
        dtInicioProposta      => 'Informa data de início da proposta',
        dtPortaria            => 'Informa data da portaria',
        numero                => 'Número do pregão',
        tx_objeto             => 'Descrição do objeto da licitação',
    };
};

has search_parameters => sub {
    return {
        co_uasg => [ 'Inteiro', 'Não', 'Número da UASG que registrou o aviso de licitação.' ],
        ds_situacao_pregao => [ 'Texto',   'Não', 'Situação do pregão.' ],
        ds_tipo_compra     => [ 'Texto',   'Não', 'Tipo de Compra.' ],
        ds_tipo_pregao     => [ 'Texto',   'Não', 'Tipo de Pregão.' ],
        nu_pregao          => [ 'Inteiro', 'Não', 'Número do pregão.' ],
        offset             => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by  => [ 'Texto', 'Não', 'Atributo utilizado para ordenação' ],
        tx_objeto => [ 'Texto', 'Não', 'Descrição do objeto da licitação.' ],
    };
};

1;

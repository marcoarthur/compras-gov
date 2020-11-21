package Compras::Model::TradingFloors;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
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

1;

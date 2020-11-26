package Compras::Model::PriceRegisters;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

has attributes => sub {
    return {
        data_assinatura      => 'Data da assinatura da licitação.',
        data_fim_validade    => 'Data de fim da validade da licitação.',
        data_inicio_validade => 'Data de início da validade da licitação.',
        id_licitacao         => 'Identificador da Licitação',
        modalidade           => 'Código da modalidade da licitação.',
        numero_aviso         => 'Número do aviso da licitação.',
        numero_itens         => 'Número de Itens.',
        situacao             => 'Situação da licitação.',
        uasg                 => 'Código da UASG.',
        valor_renegociado    => 'Valor Renegociado.',
        valor_total          => 'Valor Total.',
    };
};

1;

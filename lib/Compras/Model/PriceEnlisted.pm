package Compras::Model::PriceEnlisted;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

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

1;

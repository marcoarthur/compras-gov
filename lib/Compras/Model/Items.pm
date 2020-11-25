package Compras::Model::Items;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

has attributes => sub {
    return {
        beneficio             => 'Benefício.',
        cnpj_fornecedor       => 'CNPJ Vencedor.',
        codigo_item_material  => 'Código do Material.',
        codigo_item_servico   => 'Código do Serviço.',
        cpfVencedor           => 'CPF Vencedor.',
        criterio_julgamento   => 'Critério de Julgamento.',
        decreto_7174          => 'Decreto 7174.',
        descricao_item        => 'Descrição do item.',
        modalidade            => 'Modalidade da licitação.',
        numero_aviso          => 'Número do aviso.',
        numero_item_licitacao => 'Número do item de licitação.',
        numero_licitacao      => 'Identificador da licitação associada.',
        quantidade            => 'Quantidade de itens de licitação',
        sustentavel           => 'Se o item é sustentável',
        uasg                  => 'UASG.',
        unidade               => 'Unidade.',
        valor_estimado        => 'Valor Estimado.',
    };
};

1;

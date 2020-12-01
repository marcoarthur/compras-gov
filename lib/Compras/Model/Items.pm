package Compras::Model::Items;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/v1/itens_licitacao.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'itenslicitacao' };

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

has search_parameters => sub {

    return {
        id     => [ 'Texto', 'Sim', 'Identificador da licitação.' ],
        offset => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by    => [ 'Texto',    'Não', 'Atributo que deve ser usado como ordenador' ],
        sustentavel => [ 'Booleano', 'Não', 'Definição de sustentabilidade do item.' ],
        tipo        => [ 'Texto', 'Não', 'Tipo do item. Valores admissíveis: material ou serviço' ],
    };
};

1;

__DATA__


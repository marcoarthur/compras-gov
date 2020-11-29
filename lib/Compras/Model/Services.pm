package Compras::Model::Services;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/servicos/v1/servicos.html' };
has from_module => sub { return 'servicos' };

has attributes => sub {
    return {
        codigo           => 'Código do serviço.',
        codigo_classe    => 'Código da classe.',
        codigo_divisao   => 'Código da divisão.',
        codigo_grupo     => 'Código do grupo.',
        codigo_secao     => 'Código da seção.',
        codigo_subclasse => 'Código da subclasse.',
        cpc              => 'Código da Classificação Central de Produto.',
        descricao        => 'Descrição do serviço.',
        unidade_medida   => 'Unidade de medida do serviço.',
    };
};

has search_parameters => sub {
    return {
        classe    => [ 'Inteiro', 'Não', 'Código da classe.' ],
        cpc       => [ 'Inteiro', 'Não', 'Classificação central de produto.' ],
        descricao => [ 'Texto',   'Não', 'Descrição do serviço.' ],
        divisao   => [ 'Inteiro', 'Não', 'Código da divisão.' ],
        grupo     => [ 'Inteiro', 'Não', 'Código do grupo.' ],
        offset    => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by  => [ 'Texto',   'Não', 'Atributo utilizado para ordenação' ],
        secao     => [ 'Inteiro', 'Não', 'Código da seção.' ],
        subclasse => [ 'Inteiro', 'Não', 'Código da subclasse.' ],

    };
};

1;

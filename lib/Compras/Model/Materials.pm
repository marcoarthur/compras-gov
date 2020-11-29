package Compras::Model::Materials;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/v1/materiais.html' };
has from_module => sub { return 'materiais' };
has attributes  => sub {
    return {
        codigo      => 'Código do item de material.',
        descricao   => 'Descrição do material.',
        id_classe   => 'Código da classe de material.',
        id_grupo    => 'Código do grupo de material',
        id_pdm      => 'Código do padrão descritivo de material.',
        status      => 'Indicador se o item é ou não ativo.',
        sustentavel => 'Indicador se o item é ou não sustentável.',
    };
};

has search_parameters => sub {
    return {
        classe         => [ 'Inteiro', 'Não', 'Código da classe do material.' ],
        codigo_item    => [ 'Inteiro', 'Não', 'Código do item de material.' ],
        descricao_item => [ 'Texto',   'Não', 'Descrição do item de material.' ],
        grupo          => [ 'Inteiro', 'Não', 'Código do grupo do material.' ],
        offset         => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by    => [ 'Texto',    'Não', 'Atributo utilizado para ordenação' ],
        pdm         => [ 'Texto',    'Não', 'Código do Padrão Descritivo de Material.' ],
        sustentavel => [ 'Booleano', 'Não', 'Indicador se o item é ou não sustentável.' ],
    };
};

1;

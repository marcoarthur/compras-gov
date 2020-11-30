package Compras::Model::Institutions;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    'http://compras.dados.gov.br/docs/licitacoes/v1/orgaos.html';
};

has from_module => sub { 'licitacoes'; };
has model_name  => sub { 'orgaos'; };

has attributes => sub {
    {
        ativo              => 'Se o órgão está ativo.',
        codigo             => 'Código do órgão',
        codigo_siorg       => 'Código do siorg do órgão',
        codigo_tipo_adm    => 'Código do tipo da administração do órgão',
        codigo_tipo_esfera => 'Tipo da esfera do órgão',
        codigo_tipo_poder  => 'Código do tipo do poder do órgão',
        nome               => 'Nome do órgão.',
    };
};

has search_parameters => sub {
    return {
        ativo        => [ 'Booleano', 'Não', 'Se o órgão está ativo.' ],
        codigo_siorg => [ 'Texto',    'Não', 'Código do siorg do Órgão' ],
        nome         => [ 'Texto',    'Não', 'Descrição da modalidade de licitação.' ],
        offset       => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by    => [ 'Texto',   'Não', 'Atributo que deve ser usado como ordenador' ],
        tipo_adm    => [ 'Inteiro', 'Não', 'Código do tipo da administração do órgão' ],
        tipo_esfera => [
            'Texto',
            'Não',
'Código do tipo da esfera do órgão. F para Federal, E para estadual ou M para municipal.'
        ],
        tipo_poder => [ 'Inteiro', 'Não', 'Código do tipo de poder do órgão' ],

    };
};

1;

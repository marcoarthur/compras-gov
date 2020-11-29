package Compras::Model::PriceRegisters;
use Mojo::Base 'Compras::Model', -signatures;
use Mojo::URL;
use utf8;

has url_doc => sub {
    return Mojo::URL->new('http://compras.dados.gov.br/docs/licitacoes/v1/registros_preco.html');
};

has from_module => sub { 'licitacoes' };

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

has search_parameters => sub {
    return {
        data_assinatura       => [ 'Data', 'Não', 'Data da assinatura da licitação.' ],
        data_assinatura_max   => [ 'Data', 'Não', 'Data máxima da assinatura da licitação.' ],
        data_assinatura_min   => [ 'Data', 'Não', 'Data mínima da assinatura da licitação.' ],
        data_fim_validade     => [ 'Data', 'Não', 'Data de fim da validade da licitação.' ],
        data_fim_validade_max => [ 'Data', 'Não', 'Data máxima de fim da validade da licitação.' ],
        data_fim_validade_min => [ 'Data', 'Não', 'Data mínima de fim da validade da licitação.' ],
        data_inicio_validade  => [ 'Data', 'Não', 'Data de início da validade da licitação.' ],
        data_inicio_validade_max =>
          [ 'Data', 'Não', 'Data máxima de início da validade da licitação.' ],
        data_inicio_validade_min =>
          [ 'Data', 'Não', 'Data mínima de início da validade da licitação.' ],
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
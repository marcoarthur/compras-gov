package Compras::Model::Bids;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/v1/licitacoes.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'licitacoes' };

has attributes => sub {
    {
        data_abertura_proposta  => 'Data de abertura da proposta.',
        data_entrega_edital     => 'Data de Entrega do Edital.',
        data_entrega_proposta   => 'Data de entrega da proposta.',
        data_publicacao         => 'Data da publicação da licitação.',
        endereco_entrega_edital => 'Endereço de Entrega do Edital.',
        funcao_responsavel      => 'Função do Responsável pela Licitação.',
        identificador           => 'Identificador da Licitação.',
        informacoes_gerais      => 'Informações Gerais.',
        modalidade              => 'Código da Modalidade da Licitação.',
        nome_responsavel        => 'Nome do Responsável pela Licitação.',
        numero_aviso            => 'Número do Aviso da Licitação.',
        numero_itens            => 'Número de Itens.',
        numero_processo         => 'Número do Processo.',
        objeto                  => 'Objeto da Licitação.',
        situacao_aviso          => 'Situação do aviso.',
        tipo_pregao             => 'Tipo do Pregão.',
        tipo_recurso            => 'Tipo do Recurso.',
        uasg                    => 'Código da UASG.',
    }
};

has search_parameters => sub {
    return {

        cnpj_vencedor => [ 'Texto', 'Não', 'CNPJ do fornecedor vencedor do item de licitação.' ],
        codigo_item_filtro => [ 'Texto', 'Não', 'Código do item filtro da licitação' ],
        cpf_vencedor => [ 'Texto', 'Não', 'CPF do fornecedor vencedor do item de licitação.' ],
        data_abertura_proposta     => [ 'Data',  'Não', 'Data de abertura da proposta.' ],
        data_abertura_proposta_max => [ 'Data',  'Não', 'Data máxima de abertura da proposta.' ],
        data_abertura_proposta_min => [ 'Data',  'Não', 'Data mínima de abertura da proposta.' ],
        data_entrega_edital        => [ 'Data',  'Não', 'Data de entrega do edital.' ],
        data_entrega_edital_max    => [ 'Data',  'Não', 'Data máxima de entrega do edital.' ],
        data_entrega_edital_min    => [ 'Data',  'Não', 'Data mínima de entrega do edital.' ],
        data_entrega_proposta      => [ 'Data',  'Não', 'Data de entrega da proposta.' ],
        data_entrega_proposta_max  => [ 'Data',  'Não', 'Data máxima de entrega de proposta.' ],
        data_entrega_proposta_min  => [ 'Data',  'Não', 'Data mínima de entrega de proposta.' ],
        data_publicacao            => [ 'Data',  'Não', 'Data da publicação da licitação.' ],
        data_publicacao_max        => [ 'Data',  'Não', 'Data máxima da publicação da licitação.' ],
        data_publicacao_min        => [ 'Data',  'Não', 'Data mínima da publicação da licitação.' ],
        endereco_entrega_edital    => [ 'Texto', 'Não', 'Endereço de entrega do edital.' ],
        funcao_responsavel         => [ 'Texto', 'Não', 'Função do responsável pela licitação.' ],
        id_fornecedor => [ 'Inteiro', 'Não', 'Id do Fornecedor Vencedor.' ],
        item_material => [ 'Texto',   'Não', 'Código do item de material incluído na licitação' ],
        item_material_classificacao =>
          [ 'Texto', 'Não', 'Código da classificação do item de material incluído na licitação.' ],
        item_servico => [ 'Texto', 'Não', 'Código do item de serviço incluído na licitação' ],
        item_servico_classificacao =>
          [ 'Texto', 'Não', 'Código da classificação do item de serviço inlcuído na licitação.' ],
        modalidade       => [ 'Inteiro', 'Não', 'Código da modalidade da licitação.' ],
        nome_responsavel => [ 'Texto',   'Não', 'Nome do responsável pela licitação.' ],
        numero_aviso     => [ 'Inteiro', 'Não', 'Número da licitação.' ],
        objeto           => [ 'Texto',   'Não', 'Objeto da licitação.' ],
        offset           => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by          => [ 'Texto',    'Não', 'Atributo que deve ser usado como ordenador' ],
        orgao             => [ 'Inteiro',  'Não', 'Órgão ao qual pertence a UASG da licitação.' ],
        pregao_eletronico => [ 'Booleano', 'Não', 'Indica se o pregão é eletrônico ou não.' ],
        situacao_aviso    => [ 'Texto',    'Não', 'Situação do aviso.' ],
        sustentavel       =>
          [ 'Booleano', 'Não', 'Definição de sustentabilidade dos itens da licitação.' ],
        tipo_item      => [ 'Texto',   'Não', 'Tipo do item da licitação (material ou serviço)' ],
        uasg           => [ 'Inteiro', 'Não', 'Código da UASG.' ],
        uasg_municipio => [ 'Inteiro', 'Não', 'Código do município da UASG' ],
        uf_uasg        => [ 'Texto',   'Não', 'Unidade Federativa da UASG.' ],
        valor_estimado_total_max => [
            'BigDecimal', 'Não',
            'Valor máximo da soma dos valores estimados dos itens da licitação'
        ],
        valor_estimado_total_min => [
            'BigDecimal', 'Não',
            'Valor mínimo da soma dos valores estimados dos itens da licitação'
        ],
        valor_homologado_total_max => [
            'BigDecimal', 'Não',
            'Valor máximo da soma dos valores homologados dos itens da licitação'
        ],
        valor_homologado_total_min => [
            'BigDecimal', 'Não',
            'Valor mínimo da soma dos valores homologados dos itens da licitação'
        ],
    };
};

1;

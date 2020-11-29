package Compras::Model::NoPublicBidding;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url =>
  sub { return 'http://compras.dados.gov.br/docs/compraSemLicitacao/v1/compras_slicitacao.html' };
has from_module => sub { 'compraSemLicitacao ' };
has attributes  => sub {
    return {
        co_modalidade_licitacao => 'Tipo de compra sem licitação - código',
        co_orgao                => 'Número do órgão',
        co_uasg                 => 'Número da UASG',
        ds_fundamento_legal     => 'Descrição geral do fundamento legal',
        ds_justificativa        => 'Descrição geral da justificativa',
        ds_lei                  => 'Descrição da lei',
        ds_objeto_licitacao     => 'Descrição geral do objeto da compra',
        dtDeclaracaoDispensa    => 'Data referente ao reconhecimento da compra feita sem licitação',
        dtPublicacao            => 'Data referente à publicação da compra feita sem licitação',
        dtRatificacao           => 'Data referente à ratificação da compra feita sem licitação',
        no_cargo_resp_decl_disp =>
          'Função do responsável pelo reconhecimento da compra feita sem licitação',
        no_cargo_resp_ratificacao =>
          'Função do responsável pela ratificação da compra feita sem licitação',
        no_responsavel_decl_disp =>
          'Nome do responsável pelo reconhecimento da compra feita sem licitação',
        no_responsavel_ratificacao =>
          'Nome do responsável pela ratificação da compra feita sem licitação',
        nu_aviso_licitacao => 'Número da compra sem licitação',
        nu_inciso          => 'Inciso da lei escolhida',
        nu_processo        => 'Número do processo correspondente à forma de compra sem licitação',
        qt_total_item      => 'Quantidade de itens da compra realizada',
        vr_estimado        => 'Valor total da compra realizada',
    };
};

has search_parameters => sub {
    return {
        co_modalidade_licitacao =>
          [ 'Texto', 'Não', 'Indica qual o tipo de compra sem licitação.' ],
        co_orgao =>
          [ 'Texto', 'Não', 'Órgão responsável pela realização da compra sem licitação.' ],
        co_uasg => [ 'Texto', 'Não', 'Número da UASG responsável pela compra sem licitação.' ],
        ds_fundamento_legal => [
            'Texto', 'Não',
            'Descrição geral do fundamento legal para aquisição do objeto pretendido.'
        ],
        ds_justificativa => [
            'Texto', 'Não',
            'Descrição geral da justificativa para realização da compra sem licitação.'
        ],
        ds_lei => [
            'Texto', 'Não',
            'Lei que determina a aplicação da modalidade escolhida para o objeto pretendido.'
        ],
        ds_objeto_licitacao    => [ 'Texto', 'Não', 'Descrição geral do objeto da compra.' ],
        dt_ano_aviso_licitacao => [ 'Texto', 'Não', 'Ano da compra sem licitação.' ],
        dt_declaracao_dispensa =>
          [ 'Data', 'Não', 'Data referente ao reconhecimento da compra feita se licitação.' ],
        dt_publicacao =>
          [ 'Data', 'Não', 'Data referente à publicação da compra feita sem licitação.' ],
        dt_ratificacao =>
          [ 'Data', 'Não', 'Data referente à ratificação da compra feita sem licitação.' ],
        no_modalidade_licitacao =>
          [ 'Texto', 'Não', 'Indica qual o tipo de compra sem licitação.' ],
        nu_aviso_licitacao =>
          [ 'Texto', 'Não', 'Número da compra correspondente a compra sem licitação.' ],
        nu_inciso   => [ 'Texto', 'Não', 'Inciso da lei escolhida anteriormente.' ],
        nu_processo =>
          [ 'Texto', 'Não', 'Número do processo correspondente à forma de compra sem licitação.' ],
        offset => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente.'
        ],
        order_by      => [ 'Texto', 'Não', 'Atributo utilizado para ordenação.' ],
        qt_total_item => [ 'Texto', 'Não', 'Quantidade de itens da compra realizada.' ],
        vr_estimado   => [ 'Texto', 'Não', 'Valor total da compra realizada.' ],

    };
};

1;

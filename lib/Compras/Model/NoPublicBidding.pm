package Compras::Model::NoPublicBidding;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
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

1;

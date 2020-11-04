package Compras::Model::Bids;
use Mojo::Base 'Compras::Model';
use utf8;

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

1;

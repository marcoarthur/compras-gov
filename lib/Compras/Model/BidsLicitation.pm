package Compras::Model::BidsLicitation;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/uasg.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'licitacao' };
has template    => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}.$format} );
	<%== $url->to_abs =%>
EOT
};

has attributes => sub {
    return {
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
    };
};

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Identificador único da licitação.' ] };
};

has json_res_structure => sub {
    return {
        'links' => '/_links',
        map { $_ => "/$_" } keys %{ shift->attributes }
    };
};

1;

package Compras::Model::BidsLicitationItems;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/item_licitacao.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'licitacao' };
has submethod   => sub { 'itens' };
has template    => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}/itens.$format} );
	<%== $url->to_abs =%>
EOT
};

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
    return { id => [ 'Inteiro', 'Sim', 'Identificador da licitação.' ] };
};

1;
__DATA__


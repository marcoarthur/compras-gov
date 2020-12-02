package Compras::Model::BidsProviderItemPrice;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/v1/fornecedores_item_registro_preco.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'registro_preco' };
has template    => sub {
    return <<'EOT';
    % use Mojo::URL;
	% my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}/itens/$params->{item}/fornecedores.$format} );
	<%= $url->to_abs =%>
EOT
};

has attributes => sub {
    return {
        classificacao_fornecedor =>
          'Classificação do Fornecedor na Licitação por Registro de Preço.',
        cnpj_fornecedor       => 'CNPJ do Fornecedor do Item.',
        id_registro_preco     => 'Identificador da Licitação por Registro de Preço.',
        modalidade            => 'Código da modalidade da licitação.',
        nome_fornecedor       => 'Nome do Fornecedor do Item.',
        numero_aviso          => 'Número do Aviso da Licitação.',
        numero_item_licitacao => 'Número do Item de Licitação.',
        uasg                  => 'Código da UASG',
    };
};

has search_parameters => sub {
    return {
        id     => [ 'Texto',   'Sim', 'Identificador do Registro de Preço.' ],
        item   => [ 'Inteiro', 'Sim', 'Número do Item de Registro de Preço.' ],
        offset => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by => [ 'Texto', 'Não', 'Atributo que deve ser usado como ordenador' ],
    };
};

1;

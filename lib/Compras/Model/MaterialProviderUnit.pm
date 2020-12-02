package Compras::Model::MaterialProviderUnit;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url     => sub { return 'http://compras.dados.gov.br/docs/materiais/unidadesfornecimento.html' };
has from_module => sub { return 'materiais' };
has model_name  => sub { return 'unidadesfornecimento' };
has attributes  => sub {
    return {
        codigo       => 'Código da classe da unidade.',
        descricao    => 'Descrição da classe da unidade.',
        unidade_fornecimento => 'Nome da unidade',
    };
};

has search_parameters => sub {
    return { co_material => [ 'Inteiro', 'Não', 'Código da classe do material.' ], };
};

1;

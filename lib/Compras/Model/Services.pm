package Compras::Model::Services;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
    return {
        codigo           => 'Código do serviço.',
        codigo_classe    => 'Código da classe.',
        codigo_divisao   => 'Código da divisão.',
        codigo_grupo     => 'Código do grupo.',
        codigo_secao     => 'Código da seção.',
        codigo_subclasse => 'Código da subclasse.',
        cpc              => 'Código da Classificação Central de Produto.',
        descricao        => 'Descrição do serviço.',
        unidade_medida   => 'Unidade de medida do serviço.',
    };
};

1;

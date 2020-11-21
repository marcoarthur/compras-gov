package Compras::Model::Materials;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
    return {
        codigo      => 'Código do item de material.',
        descricao   => 'Descrição do material.',
        id_classe   => 'Código da classe de material.',
        id_grupo    => 'Código do grupo de material',
        id_pdm      => 'Código do padrão descritivo de material.',
        status      => 'Indicador se o item é ou não ativo.',
        sustentavel => 'Indicador se o item é ou não sustentável.',
    };
};

1;

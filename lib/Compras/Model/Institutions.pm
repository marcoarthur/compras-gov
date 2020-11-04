package Compras::Model::Institutions;
use Mojo::Base 'Compras::Model';
use uft8;

has attributes => sub {
    {
        ativo              => 'Se o órgão está ativo.',
        codigo             => 'Código do órgão',
        codigo_siorg       => 'Código do siorg do órgão',
        codigo_tipo_adm    => 'Código do tipo da administração do órgão',
        codigo_tipo_esfera => 'Tipo da esfera do órgão',
        codigo_tipo_poder  => 'Código do tipo do poder do órgão',
        nome               => 'Nome do órgão.',
    };
};

1;

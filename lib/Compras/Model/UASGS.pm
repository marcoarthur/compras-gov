package Compras::Model::UASGS;
use Mojo::Base 'Compras::Model';
use utf8;

has attributes => sub {
    return {
        ativo                            => 'Se a UASG está ativa.',
        cep                              => 'CEP da UASG.',
        cnpj                             => 'CNPJ da UASG',
        id                               => 'Identificador único da UASG no SICAF.',
        id_municipio                     => 'Identificador único do município da UASG.',
        id_orgao                         => 'Identificador único do órgão no SICAF.',
        nome                             => 'Nome da UASG.',
        total_fornecedores_cadastrados   => 'Quantidade total de fornecedores cadastrados na UASG.',
        total_fornecedores_recadastrados =>
          'Quantidade total de fornecedores recadastrados, no novo SICAF, na UASG.',
        unidade_cadastradora => 'Unidade cadastradora.',
    };
};


1;

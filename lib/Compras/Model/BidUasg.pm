package Compras::Model::BidUasg;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/uasg.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'uasg' };
has template => sub {
    return <<'EOT';
    % use Mojo::URL;
    % my $url = Mojo::URL->new( qq{$base/$module/id/$method/$params->{id}.$format} );
    <%= $url->to_abs =%>
EOT
};

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

has search_parameters => sub {
    return { id => [ 'Inteiro', 'Sim', 'Identificador da UASG .' ] };
};

has json_res_structure => sub {
    return {
        'links' => '/_links',
        map { $_ => "/$_" } keys %{ shift->attributes }
    };
};

1;

package Compras::Model::IrpItens;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/licitacoes/v1/itens_irp.html';
};

has from_module => sub { 'licitacoes' };
has model_name  => sub { 'irp' };
has template    => sub {
    return <<'EOT';
    % use Mojo::URL;
    % my $url = Mojo::URL->new( qq{$base/$module/doc/$method/$params->{id}/itens.$format} );
    <%= $url->to_abs =%>
EOT
};

has attributes => sub {
    return {
        codigo_material           => 'Código do Material',
        codigo_servico            => 'Código do Serviço',
        criterio_julgamento       => 'Critério de julgamento.',
        descricao_detalhada       => 'Descrição detalhada do IRP.',
        id_irp                    => 'Identificador da IRP associada ao item.',
        modalidade_licitacao_item => 'Descrição da modalidade da futura licitação da IRP.',
        numero_irp  => 'Campo com nove dígitos, dos quais quatro correspondem ao ano da IRP.',
        numero_item => 'Número do item.',
        tipo        => 'Tipo do item de IRP.',
        uasg        => 'UASG.',
        unidade_fornecimento => 'Unidade de fornecimento.',
        valor_estimado       => 'Valor Estimado.',
    };
};

has search_parameters => sub {
    return {
        id     => [ 'Texto', 'Sim', 'Identificador do Item de IRP.' ],
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

package Compras::Model::Contracts;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

has doc_url => sub {
    return 'http://compras.dados.gov.br/docs/contratos/v1/contratos.html';
};

has from_module => sub { 'contratos' };
has model_name  => sub { 'contratos' };

has attributes => sub {
    {
        cnpj_contratada       => 'CNPJ da empresa contratada.',
        codigo_contrato       => 'Tipo de Contrato.',
        cpfContratada         => 'CPF da contratada.',
        data_assinatura       => 'Data de assinatura do contrato.',
        data_inicio_vigencia  => 'Data de início de vigência dos contratos.',
        data_termino_vigencia => 'Data de término de vigência dos contratos.',
        fundamento_legal      => 'Fundamento legal do processo de contratação.',
        identificador         => 'Identificador do Contrato',
        licitacao_associada   => 'Referência à licitação que originou a contratação.',
        modalidade_licitacao  => 'Número e o ano da licitação que originou a contratação.',
        numero         => 'Campo seguido pelo número do contrato, seguido do respectivo ano.',
        numero_aditivo => 'Quantidade de termos aditivos de um contrato.',
        numero_aviso_licitacao => 'Número do aviso da licitação que originou a contratação.',
        numero_processo        => 'Número do processo de contratação.',
        objeto => 'Descrição do objeto, a partir de uma descrição de item/serviço informada.',
        origem_licitacao =>
'Origem da licitação que gerou o contrato: Preço praticado(SISPP) ou Registro de preço(SISRP).',
        uasg          => 'Campo de seis digitos que indica o código da UASG contratante.',
        valor_inicial => 'Valor inicial do contrato.',
    }
};

has search_parameters => sub {
    return {
        cnpj_contratada          => [ 'Texto', 'Não', 'CNPJ da empresa contratada.' ],
        cpf_contratada           => [ 'Texto', 'Não', 'CPF da contratada.' ],
        data_assinatura          => [ 'Data',  'Não', 'Data de assinatura do contrato.' ],
        data_assinatura_max      => [ 'Data',  'Não', 'Data máxima de assinatura do contrato.' ],
        data_assinatura_min      => [ 'Data',  'Não', 'Data mínima de assinatura do contrato.' ],
        data_inicio_vigencia     => [ 'Data',  'Não', 'Data de início de vigência dos contratos.' ],
        data_inicio_vigencia_max =>
          [ 'Data', 'Não', 'Data máxima de início de vigência dos contratos.' ],
        data_inicio_vigencia_min =>
          [ 'Data', 'Não', 'Data mínima de início de vigência dos contratos.' ],
        data_termino_vigencia => [ 'Data', 'Não', 'Data de término de vigência dos contratos.' ],
        data_termino_vigencia_max =>
          [ 'Data', 'Não', 'Data máxima de término de vigência dos contratos.' ],
        data_termino_vigencia_min =>
          [ 'Data', 'Não', 'Data mínima de término de vigência dos contratos.' ],
        fundamento_legal => [ 'Texto',   'Não', 'Fundamento legal do processo de contratação.' ],
        id_contratada    => [ 'Inteiro', 'Não', 'Identificador único da contratada.' ],
        modalidade       => [ 'Inteiro', 'Não', 'Código da modalidade da licitação.' ],
        nome_contratada  => [ 'Texto',   'Não', 'Nome da Empresa ou da Pessoa Física contratada.' ],
        numero           =>
          [ 'Inteiro', 'Não', 'Campo seguido pelo número do contrato, seguido do respectivo ano.' ],
        numero_aditivo => [ 'Inteiro', 'Não', 'Quantidade de termos aditivos de um contrato.' ],
        numero_aviso   =>
          [ 'Inteiro', 'Não', 'Número do aviso da licitação que originou a contratação.' ],
        numero_processo => [ 'Texto', 'Não', 'Número do processo de contratação.' ],
        objeto          => [
            'Texto', 'Não',
            'Descrição do objeto, a partir de uma descrição de item/serviço informada.'
        ],
        offset => [
            'Inteiro',
            'Não',
'Quantidade de registros ignorados a partir do início da lista de resultados ordenando pelo ID. Útil para paginar consultas que retornam mais que 500 resultados. Ex.: offset=3000, retorna até 500 registros ignorando os 3000 primeiros.'
        ],
        order => [
            'Texto', 'Não',
            'Atributo utilizado para indicar se ordenação é crescente ou decrescente'
        ],
        order_by         => [ 'Texto', 'Não', 'Atributo utilizado para ordenação' ],
        origem_licitacao => [
            'Texto',
            'Não',
            'Indica a origem da licitação que originou o contrato. Valores aceitos: SISRP ou SISPP'
        ],
        tipo_contrato => [ 'Inteiro', 'Não', 'Tipo de Contrato.' ],
        tipo_pessoa   =>
          [ 'Texto', 'Não', 'Tipo da pessoa contratada: Física ( PF ) ou Jurídica ( PJ )' ],
        uasg =>
          [ 'Inteiro', 'Não', 'Campo de seis dígitos que indica o código da UASG contratante.' ],
        uasg_contrato     => [ 'Inteiro',    'Não', '' ],
        valor_inicial_max => [ 'BigDecimal', 'Não', 'Valor inicial máximo do contrato.' ],
        valor_inicial_min => [ 'BigDecimal', 'Não', 'Valor inicial mínimo do contrato.' ],

    };
};

sub to_hash( $self ) {
    my $hash  = $self->SUPER::to_hash;
    my @extra = qw(nome_fornecedor nome_uasg);
    @{$hash}{@extra} = map { $self->$_ } @extra;
    return $hash;
}

sub attributes_order( $self ) {
    my $attrs = $self->SUPER::attributes_order;
    my @extra = qw(nome_fornecedor nome_uasg);
    push @$attrs, @extra;
    my @sorted = sort @$attrs;
    return \@sorted;
}

sub nome_fornecedor( $self ) {
    $self->_other->{_links}->{fornecedor}->{title};
}

sub nome_uasg( $self ) {
    $self->_other->{_links}->{uasg}->{title};
}

1;

__DATA__

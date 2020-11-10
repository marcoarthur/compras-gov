package Compras::Model::Contracts;
use Mojo::Base 'Compras::Model', -signatures;
use utf8;

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

sub to_hash( $self ) {
    my $hash = $self->SUPER::to_hash;
    $hash->{nome_fornecedor} = $self->nome_fornecedor;
    return $hash;
}

sub attributes_order( $self ) {
    my $attrs = $self->SUPER::attributes_order;
    push @$attrs, 'nome_fornecedor';
    my @sorted = sort @$attrs;
    return \@sorted;
}

sub nome_fornecedor( $self ) {
    $self->_other->{_links}{fornecedor}{title};
}

1;

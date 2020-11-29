package Compras::Model::IRPS;
use Mojo::Base 'Compras::Model';
use utf8;

has doc_url => sub {
    'http://compras.dados.gov.br/docs/licitacoes/v1/irps.html';
};

has from_module => sub { 'licitacoes' };

has attributes => sub {
    return {
        cpf_responsavel          => 'Descrição dos dados do gestor de compras responsável pela IRP',
        data_provavel_licitacao  => 'Data provável da Licitação.',
        justificativa_modalidade => 'Justificativa da modalidade.',
        modalidade_licitacao     => 'Descrição da modalidade da futura licitação da IRP.',
        municipio                => 'Código do município/UF da UASG gerenciadora da IRP.',
        nome_responsavel => 'Descrição dos dados do gestor de compras responsável pela IRP.',
        numero_aviso     => 'Número da licitação.',
        numero_irp       => 'Campo com nove dígitos, dos quais quatro correspondem ao ano da IRP.',
        objeto           => 'Descrição e/ou código do material/serviço de interesse na IRP.',
        orgao            =>
'Campo de cinco dígitos que indica o código do órgão ao qual a UASG gerenciadora pertence.',
        prazo_validade => 'Descrição do prazo de validade (em meses).',
        sigla_uf       => 'Código da UF da UASG gerenciadora da IRP',
        situacao       => 'Descrição da situação da IRP.',
        tipo_licitacao => 'Descrição do tipo de licitação.',
        uasg           =>
'Campo de seis dígitos que indica o código da UASG do gerenciador, ou seja, do resposável pela licitação gerada pela IRP.',
    };
};

has search_parameters => sub {
    return {
        cpf_responsavel =>
          [ 'Texto', 'Não', 'Descrição dos dados do gestor de compras responsável pela IRP.' ],
        data_provavel_licitacao     => [ 'Inteiro', 'Não', 'Data provável da licitação.' ],
        data_provavel_licitacao_max => [ 'Inteiro', 'Não', 'Data máxima provável da licitação.' ],
        data_provavel_licitacao_min => [ 'Inteiro', 'Não', 'Data mínima provável da licitação.' ],
        item_material => [ 'Texto', 'Não', 'Código do item de material do item incluído na IRP.' ],
        item_material_classificado =>
          [ 'Texto', 'Não', 'Código da classificação do item de material incluído na IRP.' ],
        item_servico => [ 'Texto', 'Não', 'Código do item de serviço do item incluído na IRP.' ],
        item_servico_classificado =>
          [ 'Texto', 'Não', 'Código da classificação do item de serviço incluído na IRP.' ],
        justificativa_modalidade => [ 'Texto', 'Não', 'Justificativa da modalidade.' ],
        modalidade_licitacao     =>
          [ 'Inteiro', 'Não', 'Descrição da modalidade da futura licitação da IRP.' ],
        nome_responsavel =>
          [ 'Texto', 'Não', 'Descrição dos dados do gestor de compras responsável pela IRP.' ],
        numero_aviso => [ 'Inteiro', 'Não', 'Número da licitação.' ],
        numero_irp   => [
            'Inteiro', 'Não',
            'Campo com nove dígitos, dos quais quatro correspondem ao ano da IRP.'
        ],
        objeto =>
          [ 'Texto', 'Não', 'Descrição e/ou código do material/serviço de interesse na IRP.' ],
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
        orgao    => [
            'Inteiro',
            'Não',
'Campo de cinco dígitos que indica o código do órgão ao qual a UASG gerenciadora pertence.'
        ],
        prazo_validade => [ 'Texto', 'Não', 'Descrição do prazo de validade (em meses).' ],
        situacao       => [ 'Texto', 'Não', 'Descrição da situação da IRP.' ],
        tipo_licitacao => [ 'Texto', 'Não', 'Descrição do tipo de licitação.' ],
        uasg           => [
            'Inteiro',
            'Não',
'Campo de seis dígitos que indica o código de UASG do gerenciador, ou seja, do resposável pela licitação gerada pela IRP.'
        ],
        uasg_municipio =>
          [ 'Inteiro', 'Não', 'Código do município/UF da UASG gerenciadora da IRP.' ],
        uf => [ 'Texto', 'Não', 'Unidade Federativa da UASG gerenciadora.' ],

    };
};

1;

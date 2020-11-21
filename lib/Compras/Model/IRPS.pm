package Compras::Model::IRPS;
use Mojo::Base 'Compras::Model';
use utf8;

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

1;

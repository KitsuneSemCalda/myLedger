# Plano inicial de implementação do myLedger

Estado em 2026-10-12: há um [protótipo Gum](../examples/gum-frontend.sh), um [diário fictício](../examples/demo.journal) e duas análises em [docs/research](research/). Ainda não existe um fluxo validado com dados financeiros reais. Este plano assume uso **pessoal e local**, com hledger como diário contábil e Gum como interface de tarefas frequentes.

## Objetivo do primeiro ciclo

Conseguir importar e revisar lançamentos de **uma fonte**, reconciliar o saldo com um extrato e consultar o resultado pelo terminal. Ao fim do ciclo, uma execução repetida ou um lançamento retroativo deve deixar uma diferença detectável, sem perda silenciosa. O projeto deve evitar guardar extratos, diários pessoais ou credenciais neste repositório.

O [exemplo atual](../examples/gum-frontend.sh) demonstra menu, consulta e registro manual de despesa em categorias fixas. Ele é ponto de partida, não implementação pronta para finanças reais: não configura contas, não importa extratos, não resolve escritas concorrentes e não mantém uma trilha de revisão.

## Sequência de entrega

| Etapa | Entrega | Verificação para encerrar |
| --- | --- | --- |
| 0. Levantar o fluxo real | Registrar fontes, formatos, volume mensal, tempo gasto e uma decisão recorrente; manter apenas dados agregados na documentação | Existe uma linha de base e uma fonte prioritária com extrato de referência. |
| 1. Importação auditável | Regras CSV dessa fonte, visualização prévia com `hledger import --dry-run`, confirmação antes de gravar e relatório de exceções | Mesmo arquivo duas vezes não duplica; correção retroativa e linha ausente são detectadas na comparação com o extrato. |
| 2. Conciliação | Comando para comparar saldo do hledger com saldo e data informados pelo usuário, registrar asserção e bloquear “saldo confiável” em caso de divergência | Para uma data conhecida, saldo fecha com o extrato; uma alteração que quebra a asserção causa falha visível. |
| 3. Frontend de uso diário | Separar leitura, entrada e validação; tornar conta, categorias e caminho do diário configuráveis; tratar cancelamento e erros sem gravar parcialmente | Uma despesa válida é registrada uma vez; entrada inválida, cancelamento e falha de validação deixam o diário intacto. |
| 4. Primeiro alerta | Uma regra explicável, em modo sugestão, baseada em saldo reconciliado e compromisso informado; mostrar fontes, datas e premissas | Durante quatro semanas de uso, registrar falsos alertas, alertas perdidos e se a informação ajudou a decisão. |

As etapas 0 e 1 definem se vale expandir o código. A etapa 4 só começa após a conciliação funcionar para os dados que a regra usa. As durações e metas do piloto estão na [tese quantificada](research/01-tese-quantificada.md); são hipóteses a medir, não prazos prometidos.

## Estrutura de código a buscar conforme a necessidade aparecer

- **Diário hledger:** fonte dos lançamentos, saldos e asserções. Os dados pessoais ficam fora do repositório.
- **Adaptadores de entrada:** um conjunto de regras por origem de CSV; preservar o arquivo original fora do repositório até a conciliação.
- **Comandos sem interface:** importar, verificar e calcular resultados com saída e código de erro estáveis, para poder testar sem terminal interativo.
- **Menu Gum:** selecionar tarefas, mostrar prévias e pedir confirmação; não conter regras contábeis próprias.
- **Regras de decisão:** receber saldos, datas e premissas explícitas; produzir uma sugestão com justificativa, sem movimentar dinheiro.

Shell continua adequado para orquestrar `hledger` e `gum`. Adicionar outra linguagem apenas quando uma tarefa concreta — por exemplo, normalizar um formato difícil ou comparar registros por identificador — ficar mais clara e segura nela. Não há necessidade demonstrada de banco de dados, serviço em segundo plano ou conexão bancária por API neste ciclo.

## Critérios de qualidade para cada mudança

1. Dados usados nos testes são sintéticos. Amostras reais entram só em cópia local e anonimizada quando necessário; não devem ir para commits ou logs compartilhados.
2. Toda escrita tem prévia, validação pelo hledger e possibilidade de cancelamento. Erros e divergências são visíveis ao usuário.
3. Importação é testada com repetição, sobreposição de períodos, lançamento retroativo, transferência entre contas e formato inválido, na medida em que esses casos existam na fonte escolhida.
4. Consultas que afirmem saldo disponível indicam conta, data da última reconciliação e fontes incluídas. Com saldo divergente ou vencido, o alerta não se apresenta como confiável.
5. Comparar tempo total do fluxo, inclusive correção e manutenção, com a linha de base. Ganho de tempo não compensa divergência contábil silenciosa.

## Decisões pendentes que dependem de dados reais

- Qual instituição/conta e formato de extrato entram primeiro?
- Qual é o método atual, e quanto tempo cada ciclo consome?
- Qual decisão deve ser apoiada primeiro: limite de gasto, provisão de contas, meta de reserva ou outra?
- O diário já existe e contém lançamentos manuais que precisam ser conciliados com importações?

Essas respostas guiam a primeira implementação. Até lá, a menor próxima tarefa útil é medir a etapa 0 e obter **um CSV de teste local mais um saldo de referência**, sem colocá-los no repositório.

## Critérios para mudar o plano

Se a CLI nativa do hledger cobrir o fluxo com menos trabalho, manter apenas os atalhos que economizam tempo. Se a importação por data perder correções históricas na fonte escolhida, introduzir comparação por identificador ou revisão explícita antes de automatizar novos lotes. Se a conciliação não fechar, suspender a camada de alertas e investigar a origem da divergência. Qualquer proposta de pagamentos, transferências ou investimentos automáticos requer uma avaliação separada antes de implementação.

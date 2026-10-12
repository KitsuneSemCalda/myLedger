# Pesquisa crítica: hledger, Gum e automação financeira pessoal

Data de acesso às fontes: 2026-10-12. Decisão investigada: **vale construir uma camada de scripts com interface Gum sobre o hledger para organizar finanças pessoais e apoiar decisões?** A resposta provisória é **sim, para um piloto local de importação, conferência e alertas explicáveis**. A utilidade do Gum e de uma biblioteca em várias linguagens ainda depende de demonstrar redução de atrito no uso real. A execução automática de pagamentos, transferências ou investimentos não está sustentada por esta investigação.

## Escopo e hipóteses

Parti da suposição de uma pessoa, dados locais, extratos obtidos manualmente e decisões como alertar sobre saldo disponível após contas previstas. Não há arquivos financeiros ou descrição de bancos no repositório. Se o objetivo for disponibilizar a ferramenta a terceiros, integrar contas por API ou executar transações, esta conclusão precisará de outra análise.

| Hipótese | Previsão discriminante | Resultado que a enfraquece |
| --- | --- | --- |
| H1: hledger basta como núcleo contábil | CSV pode virar lançamentos; asserções apontam diferenças; relatórios alimentam regras | Uma fonte essencial não pode ser representada ou reconciliada sem perda de informação relevante |
| H2: Gum melhora o fluxo | O ciclo completo fica mais rápido e com menos correções que CLI/editor | Menus acrescentam passos e escondem exceções que o texto deixa claras |
| H3: recomendações baseadas no diário são úteis | Uma regra simples produz alertas compreensíveis, com dados recentes e poucos alarmes falsos | Alertas dependem de saldos incompletos, classificações incertas ou previsões frágeis |
| H4: várias linguagens são necessárias | Uma tarefa específica exige biblioteca ou execução que shell+hledger não dão de forma segura e clara | A divisão cria mais formatos intermediários, estados e falhas que benefício |

## Evidência decisiva e limites

1. **O hledger já cobre parte do produto imaginado.** Seu [manual 1.52, “Deduplicating, importing”](https://hledger.org/1.52/hledger.html) descreve CSV, regras de conversão e importação com estado; a [documentação de interfaces](https://hledger.org/uis.html) lista `hledger add`, `hledger-ui` e `hledger-web`. A [documentação de exportação](https://hledger.org/export.html) mostra saídas como JSON e CSV para relatórios. Portanto, uma nova interface precisa provar valor em um fluxo específico, não apenas repetir “adicionar lançamento” ou “ver saldo”. Essa última frase é inferência de produto.
2. **A deduplicação padrão tem uma condição.** O [manual 1.52](https://hledger.org/1.52/hledger.html) a indica para fontes com ordem cronológica estável e novos registros só no fim. O [exemplo oficial de importação](https://hledger.org/import-new-transactions.html) explica o arquivo oculto `.latest.*`. Um teste local abaixo mostrou a consequência de uma transação tardia com data anterior. “Idempotente” aqui significa repetir o mesmo arquivo no fluxo previsto; não significa detectar toda correção histórica.
3. **Conciliação é a ponte entre registro e decisão.** A [documentação de verificação](https://hledger.org/checking-for-errors.html) afirma que asserções conferem saldos ao ler o diário. A [documentação de conciliação](https://hledger.org/reconciling.html) define comparar com extrato ou saldo do mundo real e procurar ausências, duplicatas e erros. Isso apoia o mecanismo de detectar divergências; não prova que os dados baixados estão completos ou corretos.
4. **Orçamento e previsão são possibilidades, não oráculos.** A [documentação de orçamento](https://hledger.org/budgeting.html) descreve metas por período e previsão por regras periódicas. Essas regras representam premissas fornecidas pelo usuário; a previsão não mede sozinha a probabilidade de uma despesa inesperada. Uma decisão baseada em previsão deve mostrar quais entradas são fatos, recorrências assumidas e lacunas.
5. **Gum oferece componentes de interação.** O [repositório oficial](https://github.com/charmbracelet/gum) documenta `choose`, `confirm`, `input`, `filter` e outros comandos. Isso sustenta sua adequação para menus, seleção e confirmação no terminal, mas não demonstra economia de tempo nem correção financeira. O [manual do Bash, “Word Splitting”](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html) mostra por que scripts que passam descrições, nomes e caminhos sem aspas podem alterar argumentos; dados financeiros fornecidos por CSV não devem virar código shell.
6. **Automação de dinheiro pode falhar com impacto real.** Em um caso de outro produto e outra jurisdição, o [CFPB registrou em 2022](https://www.consumerfinance.gov/enforcement/actions/hello-digit-llc/) que um sistema de poupança automática causou descobertos e nem sempre ressarciu taxas. É um contraexemplo à premissa “automatizar = seguro”, não uma estimativa de risco para myLedger nem uma conclusão jurídica sobre o Brasil.

### Fontes e procedência

| Fonte primária | Data/versão e trecho lido | Papel | Limite de transferência |
| --- | --- | --- | --- |
| Projeto hledger, [manual 1.52](https://hledger.org/1.52/hledger.html) | Versão 1.52; seções de importação, saída e orçamento; data de publicação não exibida | Comportamento documentado | Versão local é 1.52.1; documentação não substitui teste com extrato real. |
| Projeto hledger, [importação](https://hledger.org/import-new-transactions.html), [verificação](https://hledger.org/checking-for-errors.html) e [conciliação](https://hledger.org/reconciling.html) | Páginas acessadas em 2026-10-12; verificação marcada “Last updated: 2024”; demais datas não exibidas | Procedimentos e condições de uso | Exemplos sintéticos e descrições, não auditoria da aplicação do usuário. |
| Projeto hledger, [interfaces](https://hledger.org/uis.html) e [exportação](https://hledger.org/export.html) | Interfaces marcada “Last updated: 2026-04”; exportação marcada “Last updated: 2025” | Alternativas e formatos | Lista de interfaces não mede usabilidade para este usuário. |
| Charmbracelet, [Gum README](https://github.com/charmbracelet/gum) | Repositório acessado em 2026-10-12; versão da página não fixada; comandos documentados | Capacidade da interface | Exemplos demonstram interação, não confiabilidade contábil. |
| GNU, [Bash Reference Manual: Word Splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html) | Página acessada em 2026-10-12; edição não identificada | Mecanismo de expansão de argumentos | Aplica-se a scripts Bash; não decide por si a linguagem adequada ao projeto. |
| CFPB, [Hello Digit, LLC](https://www.consumerfinance.gov/enforcement/actions/hello-digit-llc/) | Ordem de 2022-08-10; página lida em 2026-10-12 | Contraexemplo de consequência de automação | Outro país, produto e população; não fornece frequência esperada de falhas aqui. |

## Fundamento do modelo

A cadeia causal proposta é:

```text
extrato → regra de conversão → lançamento → saldo reconciliado
        → premissas futuras explícitas → alerta → decisão humana
```

O princípio contábil usado é o registro de transações entre contas que se equilibram, como descrito na [introdução do manual do hledger](https://hledger.org/1.52/hledger.html). **Premissa verificada na documentação:** hledger verifica sintaxe, balanço das transações e asserções quando configuradas. **Premissa assumida para o piloto:** existe um extrato externo que permite conferir pelo menos uma conta. **Inferência:** uma regra baseada em saldo só merece ser exibida como confiável depois de conferir cobertura, data e saldo. O fundamento não diz que toda classificação automática representa corretamente o propósito econômico da transação; essa é uma decisão semântica a revisar.

Convém guardar separadamente o que foi **observado** (saldo de extrato, transação importada), **suposto** (despesa recorrente futura, piso de caixa) e **calculado** (saldo projetado). Essa distinção é necessária porque `--forecast` gera transações a partir de regras periódicas declaradas pelo usuário. Uma projeção pode estar aritmeticamente correta e ainda falhar por faltar uma conta ou um gasto.

## Verificação local executada

Ambiente: Linux x86_64, `hledger 1.52.1` e `gum 2.0.0`, observados por `hledger --version` e `gum --version`. O teste foi feito em diretório temporário, com CSV sintético de uma conta e um diário vazio; nenhum dado pessoal foi lido. Reproduzir com as três etapas abaixo e `hledger -f main.journal import bank.csv` após cada uma, usando regra `skip 1`, `fields date, description, amount`, `account1 assets:bank`.

| Etapa | CSV sintético | Resultado observado |
| --- | --- | --- |
| 1 | `2026-10-10,first,-10` | `imported 1 new transactions` |
| 2 | Mesmo arquivo novamente | `no new transactions found` |
| 3 | Acrescentar `2026-10-09,late_older,-5` e `2026-10-11,newer,-7`, mantendo a linha inicial | `imported 1 new transactions`; diário final contém `first` e `newer`, mas não `late_older` |

O critério definido era: reimportar o mesmo arquivo não duplicar; uma linha mais antiga adicionada depois deveria tornar visível uma limitação do fluxo. Ambos ocorreram. O teste confirma esse comportamento **nesta versão, com este arquivo e esta ordem**; não mede taxas de falha em bancos reais. O arquivo temporário foi descartado ao fim do teste.

## Alternativas sob os mesmos critérios

| Alternativa | Esforço de construção | Capacidade de conferir saldo | Valor possível para decisões | Principal custo ou limite |
| --- | --- | --- | --- | --- |
| hledger CLI, `add`, editor e regras CSV | Baixo | Asserções e conciliação disponíveis | Relatórios e orçamento já presentes | Fluxo pode exigir comandos e revisão manual. |
| Scripts curtos + Gum sobre hledger | Médio | Herda hledger se não suprimir erros; precisa preservar referência do extrato | Menus, filas de exceção e alertas específicos | Código de orquestração e estado adicional. |
| Outra TUI/web já existente para hledger | Baixo a médio para avaliar | Depende da interface | Pode resolver entrada e visualização | Ajuste ao fluxo pessoal e tratamento de exceções precisam ser testados. |
| Aplicativo financeiro fechado | Variável | Depende do produto e das fontes disponíveis | Pode ter integrações prontas | Menos controle do formato e do processamento dos dados. |

Comparação documental: a [lista oficial de UIs](https://hledger.org/uis.html) confirma alternativas, mas não há teste comparativo de tempo ou erros. O primeiro comparador empírico deve ser o método que o autor já usa; escolhê-lo após ver os resultados enviesaria o experimento.

## Piloto proposto e critérios prévios

1. **Linha de base:** durante dois ciclos, registrar tempo total, fontes, exceções e a decisão que mais se repete. Não armazenar dados privados no repositório público.
2. **Importação:** selecionar um CSV real em cópia isolada, manter o extrato original como referência, importar duas vezes e adicionar uma correção retroativa. Aceitar somente se nenhuma duplicata entrar sem aviso, toda linha ausente for detectável na conferência e o saldo da data do extrato fechar.
3. **Interface:** completar a mesma tarefa com CLI/editor e com Gum, com dados equivalentes. Medir tempo do ciclo inteiro, passos, erros de classificação e recuperabilidade após cancelar. Manter Gum se reduzir atrito sem ocultar falhas.
4. **Alerta:** por quatro semanas, mostrar uma regra em modo sugestão com saldo, data de referência, compromissos considerados e motivo. Anotar falsos positivos e falsos negativos. Suspender a regra quando a fonte estiver vencida ou divergente.

Esses testes **não foram executados**: faltam fontes, linha de base e decisões reais do usuário. Os critérios são escolhas para um piloto reversível e devem ser ajustados antes de conhecer seus resultados.

## Decisão, lacunas e parada da pesquisa

Há suporte documental e um teste local para iniciar pelo par **hledger + uma fonte reconciliada**, adicionando Gum apenas onde o fluxo manual se mostrar difícil. O desenho mais defensável é manter o diário como fonte contábil, fazer scripts apresentarem entradas e exceções, e exigir que toda recomendação exponha dados, data e premissas. Essa é uma inferência de arquitetura a testar, não uma propriedade garantida pelas ferramentas.

A pesquisa usou quatro buscas direcionadas, leu documentação primária de hledger, Gum, Bash e um caso público de falha de automação, além de um teste sintético local. Parou porque a incerteza dominante agora é **empírica e pessoal**: volume, formatos dos extratos, decisões desejadas e esforço atual. Mais documentação genérica dificilmente decide se a camada Gum economiza tempo. A próxima observação que pode mudar a conclusão é o primeiro ciclo real de importação e conciliação, sem expor os dados financeiros.

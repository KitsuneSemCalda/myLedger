# Tese quantificada: myLedger

Pesquisa em 2026-10-12. Escopo assumido: ferramenta local para **uma pessoa administrar as próprias finanças**. O projeto ainda não declara bancos, volume de lançamentos, regras de decisão ou intenção comercial; os números abaixo são hipóteses de trabalho, não medições da vida financeira do autor.

## Mudança pretendida

Transformar dados financeiros dispersos em um registro conferível e em decisões cotidianas mais rápidas: saber quanto há, o que está comprometido, o que mudou e qual ação merece atenção. O hledger seria o livro contábil; scripts de várias linguagens fariam importação, validação e cálculos; shell e Gum seriam uma interface para iniciar e revisar fluxos. A ambição real está na **confiança das decisões** e na redução de trabalho recorrente, não no número de telas.

O efeito desejado tem três degraus: (1) lançamentos corretos e conciliados; (2) sugestões explicáveis, como “esta conta ficará abaixo do piso após despesas previstas”; (3) eventual execução de ações externas. O terceiro degrau depende de autorização explícita e de evidência bem mais forte que os dois primeiros. Não há plano de venda no repositório; receita, mercado e aquisição de usuários ficam fora desta tese.

## O que já se sabe

| Entrada | Valor | Classe | Base e consequência |
| --- | --- | --- | --- |
| Estado do projeto | README de duas linhas, sem implementação | Conhecido, observado em 2026-10-12 | Ainda não há desempenho, confiabilidade ou economia de tempo medidos. |
| Ambiente local | hledger 1.52.1; Gum 2.0.0 | Conhecido, comando local | É possível testar um fluxo pequeno sem instalar ferramentas. |
| Importação do hledger | Funciona bem para CSV com ordem cronológica estável e registros novos no fim; guarda estado em `.latest.*` | Benchmark documental | O [manual 1.52](https://hledger.org/1.52/hledger.html) delimita esse caso. Correções retroativas exigem conferência própria. |
| Checagem de saldos | Asserções de saldo falham quando o diário diverge do valor esperado | Benchmark documental | [Documentação de verificação](https://hledger.org/checking-for-errors.html). É mecanismo de detecção, desde que o saldo de referência esteja certo e recente. |
| Volume mensal, contas, fontes e erros atuais | Desconhecidos | Desconhecido | Medir antes de justificar novas integrações ou automatizar dinheiro real. |

## Modelo de benefício pessoal

Unidade: **minutos por mês**. Seja `N` o número de transações, `t0` o tempo médio por transação no método atual, `t1` o tempo após automação, `M` a manutenção mensal das regras e `S` o tempo único de construção. Inclua em `t0` e `t1` importação, classificação e revisão; meça reconciliação à parte para evitar contá-la duas vezes.

```text
economia líquida mensal = N × (t0 − t1) − M
prazo de retorno em meses = (60 × S) / economia líquida mensal, se positiva
```

Exemplo **puramente ilustrativo**, para testar sensibilidade: `t0 = 1,5 min`, `t1 = 0,5 min`, `M = 60 min/mês`, `S = 20 h`. Nenhum valor foi observado no projeto.

| `N` transações/mês | Economia bruta | Economia líquida | Retorno das 20 h |
| ---: | ---: | ---: | ---: |
| 50 | 50 min/mês | −10 min/mês | Não ocorre |
| 100 | 100 min/mês | 40 min/mês | 30 meses |
| 200 | 200 min/mês | 140 min/mês | Cerca de 9 meses |

O número que mais altera a tese é `N × (t0 − t1)`, seguido da manutenção. Uma automação que poupe tempo e deixe transações ausentes **não** gera benefício aceitável. O valor pode vir de menos esquecimentos e decisões melhores, mas isso requer observação própria; não há base para atribuir um valor monetário agora.

## Escala e limites escolhidos

Estes são **alvos iniciais propostos para um piloto**, não previsões nem limites do hledger:

| Dimensão | Piloto pessoal | Expansão condicionada à prova |
| --- | --- | --- |
| Fontes | 1 conta, CSV manual | Todas as contas relevantes, cada uma com regra e reconciliação próprias |
| Histórico | 1 a 3 meses representativos | Histórico necessário para comparar tendências e sazonalidade |
| Decisões | 1 regra de alerta, sem movimentar dinheiro | Mais regras somente quando erros e lacunas forem medidos |
| Atualização | Revisão semanal | Frequência ajustada à necessidade real das decisões |
| Controle | 100% dos lançamentos importados no piloto confrontados com extrato e saldo | Nenhuma decisão automática com saldo não reconciliado ou fonte vencida |

O teste de escala aqui não é throughput de servidor. Para uma pessoa, as restrições relevantes são heterogeneidade dos extratos, atraso de dados, correções retroativas, transferências entre contas, manutenção de regras e tempo humano de auditoria. Não há medição que justifique meta de latência ou arquitetura distribuída.

## Árvore de métricas

**Resultado principal proposto:** decisões recorrentes tomadas com base em saldos e compromissos reconciliados, com menos tempo total de administração financeira. Nenhum indicador isolado representa isso bem; acompanhar conjuntamente confiabilidade e tempo evita otimizar uma dimensão às custas da outra.

| Métrica | Como colher | Cadência | Uso na decisão |
| --- | --- | --- | --- |
| Cobertura de fontes | Fontes relevantes incluídas ÷ fontes relevantes identificadas; lista mantida pelo usuário | Mensal | Impede tratar saldo parcial como visão completa. |
| Defasagem de reconciliação | Dias desde o último extrato/saldo confirmado por conta; registrar data e referência | Semanal | Alertas dependentes de saldo param quando a fonte envelhece. |
| Divergência de saldo | Valor absoluto entre hledger e extrato para a mesma conta e data | A cada importação | Divergência não explicada bloqueia recomendações financeiras daquela conta. |
| Cobertura de revisão | Lançamentos importados revisados ÷ lançamentos importados no piloto | A cada lote | Indica se a classificação automática já merece confiança. |
| Tempo líquido | Cronometrar ciclo completo antes/depois, inclusive exceções e manutenção | Mensal | Decide se o fluxo reduz esforço de fato. |
| Erro de recomendação | Casos em que um alerta acionou indevidamente ou deixou de acionar, anotados com dados disponíveis na época | Mensal | Decide se a regra deve ser corrigida ou desligada. |

As metas de erro dependem do custo de cada decisão. Para qualquer ação irreversível, a tolerância prática inicial é **zero execução sem revisão humana**. Isso é uma escolha de segurança, não uma taxa de erro estimada.

## Provas em sequência

| Prova | Pergunta | Menor evidência crível | Esforço inicial proposto | Critério para avançar |
| --- | --- | --- | --- | --- |
| Valor | O processo atual causa trabalho ou erro suficiente? | Medir 2 ciclos reais: tempo, fontes, exceções e uma decisão frequente | 1 a 2 semanas de observação | Há tarefa recorrente específica e mensurável; caso contrário, usar hledger diretamente. |
| Viabilidade | Uma fonte entra sem perda nem duplicação? | CSV real anonimizado, regras, importação repetida, extrato e correção retroativa | 1 fonte; cerca de 1 a 2 semanas de experimentos | Saldos fecham e exceções são visíveis; divergência exige redesenho. |
| Utilidade | O alerta melhora uma decisão? | Rodar 1 regra em modo sugestão por 4 semanas; registrar acertos e falsos alertas | Revisão semanal | Usuário entende a justificativa e considera o sinal útil sem confiar em saldo vencido. |
| Sustentação | A automação poupa trabalho ao longo do tempo? | Comparar tempo total e taxa de retrabalho por 2 a 3 meses | Manutenção medida | Benefício líquido positivo ou qualidade significativamente melhor por custo aceitável. |

Essas durações são **escolhas para organizar a medição**. Dependem da frequência real de transações e não prometem conclusão em calendário fixo.

## Regras de decisão da tese

- **Acelerar** a expansão de fontes quando uma fonte se mantiver reconciliada, as exceções forem rastreáveis e o ganho líquido for positivo.
- **Redesenhar** a importação quando correções retroativas, duplicatas ou transferências impedirem o fechamento de saldos; avaliar identificadores estáveis e uma etapa de revisão antes de gravar o diário.
- **Reduzir o escopo** para atalhos Gum ou scripts curtos se o hledger direto já resolver o problema com menos manutenção.
- **Suspender recomendações** dependentes de uma conta quando o saldo divergir, a fonte estiver incompleta ou os dados estiverem vencidos.
- **Não habilitar ações externas automáticas** com base apenas em um piloto de lançamentos e alertas. É uma mudança de categoria de risco, que exige outra avaliação.

## Próxima evidência que mais vale

Registrar, sem publicar dados privados, **quais fontes existem, quantos lançamentos surgem por mês, quanto tempo toma o fluxo atual e qual decisão concreta se pretende automatizar**. Isso define o denominador do benefício e separa um menu útil de uma biblioteca de automação justificável. Em seguida, testar um CSV real em cópia isolada e confrontá-lo com o extrato, incluindo um lançamento que chegue atrasado.

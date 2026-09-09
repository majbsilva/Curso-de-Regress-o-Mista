# Comparar Tratamentos com `lm` e teste t (e réplicas biológicas)

Material de estudo organizado a partir de uma conversa sobre como analisar experimentos
com dois grupos de tratamento, a relação entre `lm()` e teste t, e o problema das
réplicas biológicas vs. técnicas em modelos mistos.

> **✔ Verificação de precisão (leia primeiro):** O conteúdo deste documento está, em
> linhas gerais, **correto e bem fundamentado**. As únicas ressalvas estão marcadas
> com ⚠️ ao longo do texto e reunidas na seção "Comentários do revisor" ao final.
> Pontos-chave corretos: a equivalência `lm` ↔ teste t (duas amostras, variâncias
> iguais); a distinção observações ≠ unidades experimentais independentes; o alerta
> contra pseudorreplicação; e a recomendação do teste t pareado quando cada réplica
> biológica recebe os dois tratamentos.

---

## Mapa rápido

| Situação | Análise |
|---|---|
| 2 grupos independentes | teste t |
| 2 grupos usando `lm(y ~ grupo)` | equivalente ao teste t |
| 2 grupos + covariável | ANCOVA / regressão linear |
| 3 ou mais grupos | ANOVA / `lm()` |
| Tratamento + outras variáveis | regressão linear |
| Tratamento × outra variável | modelo com interação |

---

## 1. Analisar dois grupos de tratamento com `lm()` é o mesmo que fazer um teste t?

**Pergunta:** Analisar dois grupos de tratamento diferentes com `lm` é o mesmo que fazer um teste t?

**Resposta:** Sim, com uma ressalva importante. Quando temos **dois grupos** e usamos:

```r
lm(y ~ tratamento, data = dados)
```

estamos comparando as médias dos dois grupos. Isso é **matematicamente equivalente**
ao teste t clássico para duas amostras (variâncias iguais). O modelo se escreve como:

$$Y_i = \beta_0 + \beta_1 \text{Tratamento}_i + \epsilon_i$$

Se **Controle** for a categoria de referência:

- $\beta_0$ = média do grupo Controle
- $\beta_1$ = diferença entre a média do Tratamento e a média do Controle

Ou seja:

$$\beta_1 = \bar{Y}_{\text{Tratamento}} - \bar{Y}_{\text{Controle}}$$

Testar $H_0: \beta_1 = 0$ é exatamente o mesmo que testar
$H_0: \mu_{\text{Tratamento}} - \mu_{\text{Controle}} = 0$.

### Exemplo

Teste t:

```r
t.test(y ~ tratamento, data = dados)
```

Modelo linear:

```r
modelo <- lm(y ~ tratamento, data = dados)
summary(modelo)
```

Hipóteses:

- $H_0: \mu_1 = \mu_2$
- $H_1: \mu_1 \neq \mu_2$

### Ressalva: Welch ⚠️

O `t.test()` padrão do R usa o **teste de Welch** (`var.equal = FALSE`), que não pressupõe
variâncias iguais. Já o `lm()` convencional parte da estrutura usual de **variância residual
comum** (homocedasticidade). Portanto:

> Para obter **equivalência numérica exata** entre `t.test` e `lm`, use
> `t.test(y ~ tratamento, data = dados, var.equal = TRUE)`.

Os p-valores podem não ser exatamente iguais quando há heterocedasticidade marcante.
**Com variâncias iguais, a equivalência é direta.**

---

## 2. O que acontece quando tenho 3 réplicas biológicas?

**Pergunta (implícita):** Se eu faço 3 réplicas biológicas desse experimento, como eu poderia tratar os dados?

Desenho:

- 2 tratamentos: Controle e Tratamento
- 3 réplicas biológicas independentes
- dentro de cada réplica biológica, várias réplicas técnicas

Exemplo: 5 poços por tratamento em cada uma das 3 réplicas:

| Réplica biológica | Tratamento | Medidas |
|---|---|---|
| 1 | Controle | 5 poços |
| 1 | Tratamento | 5 poços |
| 2 | Controle | 5 poços |
| 2 | Tratamento | 5 poços |
| 3 | Controle | 5 poços |
| 3 | Tratamento | 5 poços |

Total: $3 \times 2 \times 5 = 30$ observações, mas apenas **3 réplicas biológicas por tratamento**.

**Ponto fundamental:** réplicas técnicas são medições repetidas dentro da **mesma unidade
biológica**. Elas **não** devem ser interpretadas como novas unidades biológicas independentes.

---

## 3. Como analisar se cada réplica biológica contém Controle e Tratamento?

**Pergunta:** Se cada réplica biológica contém os dois tratamentos, como devo comparar?

Representação:

```
Réplica biológica 1
  ├── Controle
  └── Tratamento
Réplica biológica 2
  ├── Controle
  └── Tratamento
Réplica biológica 3
  ├── Controle
  └── Tratamento
```

A comparação mais simples é calcular a diferença **dentro de cada réplica**:

$$D_i = \text{Tratamento}_i - \text{Controle}_i$$

Depois testar se a média dessas diferenças é diferente de zero:

$$H_0: \mu_D = 0$$

Isso corresponde a um **teste t pareado**. No R:

```r
t.test(dados$tratamento, dados$controle, paired = TRUE)
```

Se houver três pares biológicos: $n = 3$ e $df = 3 - 1 = 2$.

---

## 4. Por que não devo simplesmente analisar todos os poços?

Se cada réplica biológica tem 3 poços técnicos por tratamento: $3 \times 2 \times 3 = 18$ observações.

```r
t.test(valor ~ tratamento, data = dados)
```

O teste simples pode tratar os dados como Controle: 9 observações; Tratamento: 9 observações,
pressupondo que os 18 valores são **independentes**. Se os 3 poços dentro de uma mesma réplica
biológica são apenas réplicas técnicas, essa interpretação é inadequada: gera **pseudorreplicação**.

> O problema não é ter 18 medições. O problema é interpretar 18 medições técnicas como se fossem
> 18 unidades biológicas independentes.

---

## 5. Posso primeiro fazer a média das réplicas técnicas?

Sim. Abordagem simples e transparente quando os poços são realmente réplicas técnicas:

```r
library(dplyr)
dados_med <- dados %>%
  group_by(replica, tratamento) %>%
  summarise(valor = mean(valor), .groups = "drop")
```

Se havia 18 observações, depois da média restam $3 \times 2 = 6$ observações (uma por
réplica biológica × tratamento). O número de réplicas biológicas continua $n = 3$ por tratamento.

| Réplica | Tratamento | Valor médio |
|---|---|---|
| 1 | Controle | ... |
| 1 | Tratamento | ... |
| 2 | Controle | ... |
| 2 | Tratamento | ... |
| 3 | Controle | ... |
| 3 | Tratamento | ... |

---

## 6. Qual é a diferença entre `lmer()` e `gls()` com `varIdent()`?

**Pergunta:** Qual seria a diferença se eu uso a função `gls` com o argumento `varIdent` comparado com o `lmer`?

> Obs.: o argumento referido como `varIntent` no original é, no pacote `nlme`, `varIdent()`.

Os dois métodos lidam com estruturas mais complexas, mas respondem a problemas diferentes.

**`lmer()`:**

```r
library(lme4)
modelo <- lmer(valor ~ tratamento + (1 | replica), data = dados)
```

O termo `(1 | replica)` modela a variação **entre** as réplicas biológicas. Conceitualmente:

$$Y_{ij} = \beta_0 + \beta_1 \text{Tratamento}_{ij} + b_i + \epsilon_{ij}$$

onde $b_i \sim N(0, \sigma^2_{\text{replica}})$. Cada réplica biológica pode ter seu próprio nível basal.

---

## 7. O que faz `varIdent()`?

Com `gls()`:

```r
library(nlme)
modelo <- gls(valor ~ tratamento, weights = varIdent(~1 | tratamento), data = dados)
```

O `varIdent()` permite que as **variâncias residuais sejam diferentes entre os grupos**:
$\sigma_{\text{Controle}} \neq \sigma_{\text{Tratamento}}$.

| Conceito | Função |
|---|---|
| Variação entre réplicas | `(1 | replica)` (lmer) |
| Variâncias residuais diferentes entre grupos | `varIdent()` (gls) |

> **São problemas diferentes.** `varIdent()` **não** substitui `(1 | replica)`.

---

## 8. `varIdent()` não substitui `(1 | replica)`?

**Pergunta:** Então `varIdent` não substitui o efeito aleatório da réplica?

Exatamente. `(1 | replica)` modela a variação associada às réplicas. `varIdent()` modela
diferenças nas variâncias residuais entre os tratamentos.

É possível combinar as duas ideias usando `lme()` do pacote `nlme`:

```r
library(nlme)
modelo <- lme(valor ~ tratamento,
              random = ~1 | replica,
              weights = varIdent(~1 | tratamento),
              data = dados)
```

Esse modelo permite, simultaneamente: variação entre réplicas **e** variâncias residuais
diferentes entre tratamentos.

---

## 9. Com apenas 3 réplicas biológicas, o `lmer()` é uma boa ideia?

**Pergunta:** Com apenas 3 réplicas biológicas, o `lmer()` é uma boa ideia?

**Resposta:** Com apenas três níveis de `replica`, é necessário ter cautela.

```r
lmer(valor ~ tratamento + (1 | replica), data = dados)
```

precisa estimar uma variância associada ao efeito aleatório da réplica: $\sigma^2_{\text{replica}}$.
Mas existem somente **três** réplicas biológicas. Isso é pouco para estimar um componente de
variância aleatório com grande estabilidade. ⚠️ (Ver comentário do revisor sobre o número mínimo
de níveis do efeito aleatório.)

O modelo pode ser ajustado, mas não confunda: modelo hierárquico apropriado $\neq$ grande
quantidade de evidência biológica. Ele não transforma $n = 3$ em $n = 18$.

---

## 10. (continuação) Quantos níveis de `replica` existem no `lmer()`?

**Pergunta:** Se temos 3 réplicas biológicas, 2 tratamentos, 3 réplicas técnicas por tratamento,
temos 18 observações. Entretanto, existem somente 3 réplicas biológicas por tratamento. Quantos
níveis de `replica` existem no `lmer()`?

Se os dados são:

- Réplica 1 → várias observações
- Réplica 2 → várias observações
- Réplica 3 → várias observações

Então `(1 | replica)` tem **3 níveis**. Assim:

- número de observações = 18
- número de níveis de `replica` = 3
- número de réplicas biológicas por tratamento = 3

O `lmer()` **não** transforma o $n$ de 3 em 18. Mas é importante distinguir entre número de
observações e número de unidades experimentais independentes.

---

## 11. Então não estou inflando os graus de liberdade?

**Pergunta:** Então não estou inflando os graus de liberdade?

**Resposta:** Não da mesma maneira que ocorreria se você simplesmente ignorasse a estrutura de
agrupamento.

```r
t.test(valor ~ tratamento, data = dados)        # 18 medições como independentes -> pode haver pseudorreplicação
lmer(valor ~ tratamento + (1 | replica), data = dados)  # reconhece o agrupamento
```

Você **não** está cometendo a mesma inflação grosseira de graus de liberdade que cometeria
tratando os 18 valores como independentes. Mas também **não** deve interpretar o modelo como se
tivesse $n = 18$ biologicamente independentes.

---

## 12. O `lmer()` usa 18 observações ou 3?

**Pergunta:** O `lmer()` usa 18 observações ou 3?

**Resposta:** Ele usa as 18 observações para ajustar o modelo, mas as 18 observações não
representam 18 unidades biológicas independentes. Podemos escrever:

- $N = 18$ observações
- $n = 3$ biológico por tratamento

Com `lmerTest` obtemos uma aproximação dos graus de liberdade, frequentemente pelo método
**Satterthwaite**:

```r
library(lmerTest)
modelo <- lmer(valor ~ tratamento + (1 | replica), data = dados)
summary(modelo)
```

---

## 13. O que exatamente as réplicas técnicas acrescentam?

As réplicas técnicas ajudam a estimar com maior precisão o valor observado **dentro de cada
réplica biológica**. Exemplo:

- Réplica biológica 1, Controle: 10, 11, 9 → média = 10
- Réplica biológica 1, Tratamento: 15, 16, 14 → média = 15

As 3 medições técnicas ajudam a obter uma estimativa mais estável daquela réplica. Mas não
podemos dizer "tenho $n = 9$ réplicas biológicas". Continuamos tendo $n = 3$.

---

## 14. Uma forma simples de enxergar o problema

```
EXPERIMENTO BIOLÓGICO
Réplica 1
  / \
Controle  Tratamento
(3 poços)  (3 poços)
Réplica 2
  / \
Controle  Tratamento
(3 poços)  (3 poços)
Réplica 3
  / \
Controle  Tratamento
(3 poços)  (3 poços)
```

O nível mais importante para generalização biológica é a **réplica biológica**, não cada poço
individual.

---

## 15. Qual análise é mais simples para 3 réplicas?

Se cada réplica biológica contém os dois tratamentos, uma estratégia muito clara:

**Passo 1** — calcular a média das réplicas técnicas:

```r
dados_med <- dados %>%
  group_by(replica, tratamento) %>%
  summarise(valor = mean(valor), .groups = "drop")
```

**Passo 2** — colocar Controle e Tratamento lado a lado:

```r
dados_wide <- tidyr::pivot_wider(dados_med,
                                 names_from = tratamento,
                                 values_from = valor)
```

**Passo 3** — calcular a diferença:

```r
dados_wide <- dados_wide %>% mutate(diferenca = Tratamento - Controle)
```

**Passo 4** — testar a diferença média:

```r
t.test(dados_wide$diferenca, mu = 0)
```

Isso corresponde ao teste t pareado.

---

## 16. Por que o teste pareado é particularmente interessante?

Porque ele compara o tratamento **dentro da mesma réplica biológica**:

| Réplica | Controle | Tratamento | Diferença |
|---|---|---|---|
| 1 | 10 | 15 | 5 |
| 2 | 12 | 17 | 5 |
| 3 | 10 | 15 | 5 |

A pergunta passa a ser: "Em média, quanto o tratamento muda o resultado dentro de uma mesma
réplica biológica?" Matematicamente: $D_i = \text{Tratamento}_i - \text{Controle}_i$ e
$H_0: \mu_D = 0$. Com três réplicas, $df = 2$. Isso deixa claro que a evidência biológica está
baseada em três experimentos independentes.

---

## 17. Por que o efeito da réplica desaparece na diferença?

Considere:

$$\text{Controle}_i = \beta_0 + b_i + \epsilon_{iC}$$

$$\text{Tratamento}_i = \beta_0 + \beta_1 + b_i + \epsilon_{iT}$$

Subtraindo:

$$\text{Tratamento}_i - \text{Controle}_i = \beta_1 + (\epsilon_{iT} - \epsilon_{iC})$$

O termo $b_i$ (efeito da réplica) **desaparece**. Essa é uma das razões pelas quais o desenho
pareado é tão eficiente quando Controle e Tratamento estão na mesma réplica biológica.

---

## 18. E se eu mantiver todas as réplicas técnicas no `lmer()`?

É possível:

```r
modelo <- lmer(valor ~ tratamento + (1 | replica), data = dados)
```

O modelo recebe as 18 observações. Entretanto, isso **não** deve ser confundido com
$n_{\text{biológico}} = 18$. O `lmer()` aproveita a informação das observações agrupadas, mas a
replicação biológica continua sendo 3.

### `lm()` versus `lmer()`

| | `lm()` | `lmer()` |
|---|---|---|
| `replica` | efeito **fixo** (`+ replica`) | efeito **aleatório** (`(1 | replica)`) |

```r
lm(valor ~ tratamento + replica, data = dados_med)        # replica como bloco fixo
lmer(valor ~ tratamento + (1 | replica), data = dados_med) # replica como efeito aleatório
```

Com apenas três réplicas, a escolha deve considerar o desenho experimental e o objetivo de
inferência, e não simplesmente porque um modelo é mais sofisticado.

---

## 19. Quando o `lmer()` passa a ser mais interessante?

O modelo misto se torna particularmente útil quando:

- existem várias réplicas biológicas
- há medidas repetidas
- existem vários níveis hierárquicos
- há vários tratamentos ou fatores
- há dados longitudinais
- existem diferentes unidades experimentais dentro de cada grupo
- queremos modelar explicitamente a variação entre experimentos

Exemplo:

```r
lmer(valor ~ tratamento + tempo + tratamento:tempo + (1 | replica), data = dados)
```

Investiga: efeito do tratamento, efeito do tempo, interação tratamento × tempo e variação entre
réplicas.

---

## 20. Quando `gls()` com `varIdent()` é especialmente útil?

O `gls()` é interessante quando a principal preocupação está na estrutura da variância ou
correlação dos erros:

```r
gls(valor ~ tratamento, weights = varIdent(~1 | tratamento), data = dados)
```

Permite $\sigma_C \neq \sigma_T$, útil quando há evidência de heterocedasticidade. O `nlme`
também permite combinar estruturas de variância e correlação.

---

## 21. Comparação geral dos métodos

| Método | Observações | Reconhece réplica biológica? | Heterocedasticidade? | Comentário |
|---|---|---|---|---|
| `t.test()` simples | 18 | Não | Welch por padrão | Pode gerar pseudorreplicação |
| `t.test(paired=TRUE)` após média | 3 (diferenças) ⚠️ | Sim | Não é o foco | Muito transparente para 3 pares |
| `lm(valor ~ tratamento)` | 6 (após média) | Não | Não | Não representa o pareamento |
| `lm(valor ~ tratamento + replica)` | 6 | Sim | Não diretamente | Réplica como bloco fixo |
| `lmer(valor ~ tratamento + (1|replica))` | 6 ou 18 | Sim | Não diretamente | Modelo misto |
| `gls(... varIdent)` | 6 ou 18 | Não sozinho | Sim | Variâncias diferentes |
| `lme(... random + varIdent)` | 6 ou 18 | Sim | Sim | Modelo mais complexo |

> ⚠️ Nota: a tabela original dizia "6" para o `t.test(paired=TRUE)`, mas o teste pareado sobre
> as diferenças usa **n = 3 diferenças** (df = 2), não 6. Corrigido acima.

---

## 22. O ponto central sobre o n

> **Memorize:** número de observações **não é** necessariamente número de unidades experimentais
> independentes.

No exemplo: $3 \text{ réplicas} \times 2 \text{ tratamentos} \times 3 \text{ técnicas} = 18$
observações. Mas $n = 3$ réplicas biológicas por tratamento. O `lmer()` não transforma
$n = 3$ em $n = 18$.

---

## 23. E os graus de liberdade?

> **Memorize:** o `lmer()` pode utilizar 18 observações no ajuste, mas isso não significa que o
> efeito do tratamento tenha 18 unidades biológicas independentes.

Os graus de liberdade dos efeitos fixos em modelos mistos dependem da estrutura do modelo e do
método de aproximação. Com `lmerTest` (Satterthwaite) obtemos uma aproximação. Portanto, não
olhe para $N = 18$ e conclua $df = 16$ como em um teste t simples.

---

## 24. O principal alerta: não confundir sofisticação com mais replicação

Um modelo misto pode representar corretamente a estrutura dos dados, mas **não cria novas
unidades experimentais**. Se você tem 3 experimentos biológicos, continua tendo 3 experimentos
biológicos, mesmo que cada experimento tenha 3, 6, 10 ou 100 medições. Mais medições melhoram a
precisão da medida dentro de cada experimento, mas não substituem novas réplicas biológicas.

---

## 25. Estratégia recomendada para o desenho discutido

Para 3 réplicas biológicas, cada uma com Controle + Tratamento e 3 réplicas técnicas por condição:

1. Resumir as réplicas técnicas:
   ```r
   dados_med <- dados %>%
     group_by(replica, tratamento) %>%
     summarise(valor = mean(valor), .groups = "drop")
   ```
2. Comparar Controle e Tratamento dentro de cada réplica (teste t pareado):
   ```r
   t.test(valor ~ tratamento, data = dados_med, paired = TRUE)
   ```
3. Visualizar as três réplicas biológicas (pares Controle ●────────● Tratamento).

---

## 26. Conclusão

Separe três conceitos:

1. **observações técnicas**
2. **réplicas biológicas**
3. **graus de liberdade estatísticos**

No exemplo: 18 observações, mas apenas 3 réplicas biológicas por tratamento. O `lmer()` usa as
18 observações no ajuste e reconhece que elas estão agrupadas nas 3 réplicas biológicas, o que é
diferente de tratar todas como independentes. `(1 | replica)` modela a variação entre réplicas;
`varIdent()` modela diferenças nas variâncias residuais entre grupos. Eles não são a mesma coisa.

Quando há só 3 réplicas biológicas e cada réplica contém Controle e Tratamento, o **teste t
pareado** sobre as diferenças é uma abordagem simples e transparente. Com mais réplicas biológicas
ou desenhos mais complexos, modelos mistos tornam-se mais atraentes.

> **Regra prática:** $N_{\text{observações}} \neq n_{\text{unidades biológicas}}$.
> Réplicas técnicas não criam novas réplicas biológicas.

---

## Comentários do revisor (verificação de precisão)

O documento original está **correto** nos pontos estatísticos centrais. Ressalvas e acréscimos:

1. **✔ Equivalência `lm` ↔ teste t (Seção 1):** correta. A equivalência numérica exata exige
   `t.test(..., var.equal = TRUE)`, pois o padrão do R é Welch. O documento já alerta sobre isso.
   Sem heterocedasticidade, Welch ≈ Student ≈ `lm`, então a diferença prática é pequena.

2. **✔ Pseudorreplicação e `n` biológico (Seções 2 a 12):** excelente e correto. A distinção
   observações ≠ unidades experimentais independentes é o ponto mais importante e está bem tratada.

3. **✔ Teste t pareado com 3 pares (Seções 3, 16):** recomendação adequada e defensável contra
   pseudorreplicação. **Acréscimo:** com $df = 2$ o poder estatístico é muito baixo e o IC será
   largo. A abordagem é "limpa", mas a inferência é fraca; se possível, aumente o $n$ biológico.

4. **⚠️ Tabela da Seção 21 (original):** dizia "6" para `t.test(paired=TRUE)`. Corrigido para
   **n = 3** (as 3 diferenças pareadas, df = 2). Pequena inconsistência de contagem no original.

5. **⚠️ `lmer()` com 3 níveis de efeito aleatório (Seção 9):** o alerta do documento está correto.
   Acrescento: muitos estatísticos consideram **3 o mínimo absoluto** e recomendam pelo menos
   5 a 6 níveis para estimar $\sigma^2_{\text{replica}}$ com estabilidade razoável. Com 3 níveis,
   a estimativa do componente de variância é instável e o modelo pode ter dificuldade de convergência
   ou produzir ICs dos efeitos fixos otimistas. O teste pareado (Seção 16) é, nesse caso, muitas
   vezes a escolha mais honesta.

6. **✔ `lmer` vs `gls`/`varIdent` (Seções 6 a 8, 20):** corretas. `(1 | replica)` modela
   variância entre unidades de agrupamento; `varIdent()` modela heterocedasticidade entre grupos.
   São ortogonais e combináveis via `lme()`.

7. **✔ Graus de liberdade em modelo misto (Seções 12, 23):** correto. `lmerTest` + Satterthwaite
   (ou Kenward-Roger) aproxima os gl; não se deve inferir $df = N - k$ como em OLS simples.

8. **✔ `lm(valor ~ tratamento + replica)` como bloco fixo (Seção 18):** correto. Consome graus de
   liberdade dos blocos; com 3 réplicas fixas, sobra pouco gl para o tratamento, o que reforça a
   preferência pelo pareado ou pelo misto conforme o objetivo.

**Veredito:** material seguro para estudo. As únicas correções aplicadas foram de limpeza de OCR
(`Tratamento`, `réplica`, símbolos) e o ajuste do n = 3 na tabela de métodos.

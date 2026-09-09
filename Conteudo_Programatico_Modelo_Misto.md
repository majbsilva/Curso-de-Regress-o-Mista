# Conteúdo Programático: Modelos Mistos (Efeitos Fixos e Aleatórios)

Material didático para o curso de Bioestatística em R. Público-alvo: alunos de pós-graduação, professores e profissionais da pesquisa que precisam analisar dados de estudos e experimentos, mas têm pouca familiaridade com estatística e com a linguagem R.

Cada ponto do roteiro virou um módulo teórico em Quarto (arquivo-mestre com código completo + template do aluno). Dois casos práticos acompanham a teoria. Tudo segue o fluxo de `Dinamica_e_Fluxo_de_Arquivos.md` e as diretrizes de `CLAUDE.md`.

Referências-base do curso:
- Harrell, F. E. (2015). *Regression Modeling Strategies*. Springer. (Modelagem explícita da estrutura de covariância dos dados.)
- Field, A., Miles, J., e Field, Z. (2012). *Discovering Statistics Using R*. Sage. (Porta de entrada em modelos multinível / efeitos mistos.)

---

## 1. Por que usar modelo misto

Na pesquisa, raramente temos observações independentes: o mesmo paciente medido em vários momentos, o mesmo animal em várias pesagens, a mesma placa em vários tempos. As medidas de um grupo se parecem mais entre si. A regressão comum (`lm`) trata cada linha como independente, subestima o erro-padrão e entrega falso positivo. Harrell defende modelar a covariância como parte do modelo; Field usa isso como porta de entrada para multinível.

## 2. Conceitos essenciais, sem jargão

- **Efeito fixo**: influência que queremos estimar e interpretar (fármaco vs placebo, dieta, tempo). Perguntamos o tamanho do efeito.
- **Efeito aleatório**: variação do agrupamento que descrevemos só pela dispersão (linha de base por paciente, condição por hospital, ruído por lote). Perguntamos quanto da variação vem dos grupos.
- Equação: resposta = efeitos fixos + efeitos aleatórios + erro.

## 3. Quando usar modelo misto (e quando não)

Use com medidas repetidas, estrutura hierárquica ou para generalizar além dos grupos amostrados. Não use com observações independentes (basta `lm`) nem quando se quer estimar cada grupo individualmente (use fixo). A escolha muda o erro-padrão: o `lmer` corrige a dependência que o `lm` ignora.

## 4. Estrutura do modelo

Forma linear: `y = X * beta + Z * b + e`. No R: `lmer(resposta ~ fixos + (1 | grupo), data = d)`. O `(1 | grupo)` é a interceptação aleatória. A saída traz `Random effects` (variância entre grupos) e `Fixed effects` (estimativas).

## 5. Exemplo prático em R: medidas repetidas

Cenário de bancada: pacientes hipertensos em três visitas (0, 30, 60), dois tratamentos. `lmer(pas ~ tratamento * fator(visita) + (1 | paciente))`. O termo `tratamento:visita` revela se a diferença muda no tempo. Sem o termo aleatório, o erro-padrão sai subestimado.

## 6. Como escolher a estrutura aleatória

Comece simples e amplie só se os dados pedirem: `(1 | id)`, `(1 + tempo | id)`, `(1 | hospital/id)`. Compare por AIC/BIC e razão de verossimilhança. Não inclua efeito aleatório por capricho (consome graus de liberdade e pode impedir convergência).

## 7. Diagnóstico do modelo

Antes de confiar: resíduos aproximadamente normais (QQ), variância aleatória plausível, convergência sem avisos, sem colinearidade excessiva. Field trata o exame de resíduos como obrigatório.

## 8. Modelos mistos estendidos

Mesma lógica de fixos/aleatórios; muda a função de ligação. Binária com `glmer` (família binomial), contagens com Poisson/binomial negativa, sobrevida com fragilidade mista.

## 9. Erros frequentes dos iniciantes

Tratar repetidas como independentes; confundir fixo com aleatório; interpretar aleatório como estimativa de grupo; esquecer o diagnóstico; usar `lm` quando deveria ser `lmer`.

## 10. Roteiro de exercícios sugeridos

Animais em três pesagens (`lmer` com `(1|animal)`); comparar `lm` vs `lmer` no erro-padrão; inclinação aleatória via AIC; `glmer` para resposta binária; contrastes com `emmeans` no caso sleepstudy; mapear a interceptação aleatória no caso esferoides.

---

## Módulos produzidos (Quarto / .qmd)

Cada módulo tem arquivo-mestre (código completo) e template do aluno (código vazio com dicas), gerados por `_ferramentas/gerar_template.R`.

### Teóricos (1 a 10)
- Módulo 1 - Por que modelo misto
- Módulo 2 - Efeito fixo e aleatório
- Módulo 3 - Quando usar
- Módulo 4 - Estrutura do modelo
- Módulo 5 - Exemplo prático em R (medidas repetidas)
- Módulo 6 - Como escolher a estrutura aleatória
- Módulo 7 - Diagnóstico do modelo
- Módulo 8 - Modelos mistos estendidos
- Módulo 9 - Erros frequentes dos iniciantes
- Módulo 10 - Roteiro de exercícios

### Casos (C1, C2)
- **C1 - sleepstudy** (`Módulo C1 - sleepstudy`): intuição com dataset embutido (18 sujeitos, 10 dias). Liga regressão comum ao misto, `(1|Subject)` a `(Days|Subject)`, médias ajustadas, diagnóstico. Referências: Harrell, Field, Bates et al.
- **C2 - esferoides** (`Módulo C2 - Esferoides`): caso de bancada (8 tratamentos, 2 tempos, 7 esferoides). Escala log, variância heterogênea (`varIdent`), modelo pareado (`gls`), Dunnett exato (`mvt`), três figuras de artigo.

### Sugestão de sequência de aula
Teóricos 1 a 5, Caso C1, Teóricos 6 a 7, Caso C2, Teóricos 8 a 10.

---

## Referências práticas para o aluno

- `lme4` (Bates et al.) para modelos mistos lineares; `lmerTest` para p-valores; `emmeans` para médias ajustadas; `nlme` para variância modelada (`lme`, `gls`), usado no caso esferoides.
- Harrell (2015) e Field, Miles e Field (2012) como textos de apoio teórico.
- Documentação e vignettes dos pacotes, lidas junto com este roteiro.

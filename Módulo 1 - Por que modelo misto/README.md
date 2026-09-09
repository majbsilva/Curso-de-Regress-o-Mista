# Módulo 1 - Por que usar modelo misto

Por que a regressão comum não basta e como os dados agrupados exigem o modelo misto.

## O que o aluno faz neste módulo

O aluno entende que, quando as medidas não são independentes (mesmo sujeito, mesmo lote, mesmo hospital), a regressão comum subestima o erro-padrão e entrega conclusões falsas. O modelo misto separa efeitos fixos (o que interpretamos) de efeitos aleatórios (a variação entre grupos).

## Arquivo principal

- Mestre: `Módulo 1 - Por que modelo misto.qmd`
- Template do aluno: `Módulo 1 - Por que modelo misto — TEMPLATE.qmd` (gerado a partir do mestre)

## Como rodar

1. Abra o projeto R do curso (Curso de Regressão Mista.Rproj) no RStudio.
2. Abra o arquivo-mestre em Quarto e rode bloco a bloco, OU abra o template e preencha junto com o professor.
3. Depois, renderize o HTML para revisão: `quarto render "Módulo 1 - Por que modelo misto.qmd"`.

## Próximo passo

[Módulo 2 - Efeito fixo e aleatorio](../Módulo%202%20-%20Efeito%20fixo%20e%20aleatorio/README.md)

## Observação

Os templates são gerados automaticamente a partir do mestre com `_ferramentas/gerar_template.R`. Não edite o template diretamente.

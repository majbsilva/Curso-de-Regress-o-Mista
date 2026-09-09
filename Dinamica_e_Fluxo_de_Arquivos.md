# Dinâmica da aula e fluxo de arquivos

## O que é este curso

Curso online e ao vivo (síncrono), no formato teórico-prático com *live coding*. O professor lê a narrativa e digita o código na frente dos alunos, que acompanham digitando junto. Cada módulo nasce de um único arquivo-mestre e, dele, saem de forma automática os dois materiais que o aluno usa: o template para preencher e a referência renderizada.

## Os três arquivos de cada módulo

1. **Arquivo-mestre (`*.qmd` completo):** texto da aula mais todo o código já escrito e funcionando. É o único arquivo que o professor edita.
2. **Template do aluno (`... — TEMPLATE.qmd`):** copia do mestre, mas com os blocos de código vazios e uma dica (comentário) em cada um. O aluno abre no RStudio e preenche durante a aula.
3. **Referência renderizada (`*.html`):** o mestre renderizado em HTML (texto, código e resultados). O aluno revisa depois da aula.

Esquema do fluxo:

```
        arquivo-mestre.qmd        (professor edita)
                  |
          ----------+----------
          |                     |
   gerar_template.R        render (Quarto)
          |                     |
          v                     v
  ... — TEMPLATE.qmd      arquivo-mestre.html
   (aluno preenche)       (aluno revisa)
```

## A dinâmica da aula (live coding)

**Antes da aula:**
- Professor termina e revisa o arquivo-mestre.
- Roda `gerar_template()` para gerar o template do aluno.
- Disponibiliza o mestre e o template para a turma.

**Durante a aula:**
- Professor abre o mestre e narra a teoria.
- Digita o código bloco a bloco, explicando cada passo.
- Alunos abrem o template e digitam o mesmo código, usando as dicas nos comentários.
- Dúvidas surgem em tempo real e são resolvidas no vivo.

**Depois da aula:**
- Professor renderiza o mestre em HTML (botão Render ou `quarto render`).
- Aluno revê o HTML com código e saída corretos, compara com o que digitou e consolida o aprendizado.

## Como gerar o template (no Console do RStudio)

Com o Projeto do curso aberto, carregue a função e aponte para o mestre:

```r
source("_ferramentas/gerar_template.R")

# um módulo:
gerar_template("Módulo 9 - Esferoides/modelo_misto_esferoides.qmd")

# ou todos de uma vez:
gerar_todos(".")
```

A função `gerar_template()` faz o seguinte:
- Lê o mestre linha a linha.
- Mantém tudo que está fora dos blocos de código (texto, títulos, chamadas).
- Dentro dos blocos ` ```{r} `, mantém apenas comentários (as dicas) e linhas em branco, e apaga as linhas de código.
- No cabeçalho, troca o título para indicar "Template" e insere um aviso de callout.
- Salva como `<nome> — TEMPLATE.qmd` na mesma pasta.

`gerar_todos(".")` varre a pasta, ignora os arquivos que já terminam em TEMPLATE e gera o template de cada mestre encontrado.

## Como gerar a referência HTML

No RStudio, com o mestre aberto, clique em **Render**. Ou pelo Console/terminal:

```r
quarto::quarto_render("caminho/para/modulo.qmd")
```

O resultado é um `.html` pronto para disponibilizar.

## Exemplo real: modelo misto para esferoides

O arquivo `modelo_misto_esferoides.qmd` é o mestre de um estudo de caso completo (companheiro do Módulo 9). Ele cobre, do início ao fim:

- Leitura e preparação dos dados de 8 tratamentos e 2 tempos.
- Escolha da escala log da área.
- Construção do modelo misto passo a passo, com comparação de estruturas de variância.
- Diagnóstico dos resíduos.
- Resultados (crescimento por tratamento e comparação com o controle).
- Três figuras no formato de artigo e exportação das tabelas.

Ao rodar `gerar_template()` sobre ele, nasce `modelo_misto_esferoides — TEMPLATE.qmd`, com cada bloco de código vazio e a dica preservada, pronto para o aluno digitar junto.

## Resumo do ciclo

1. Edite só o mestre.
2. `gerar_template()` cria o template do aluno.
3. `quarto render` cria a referência HTML.
4. Na aula, aluno digita no template; depois revisa no HTML.
5. Se o mestre mudar, rode `gerar_template()` de novo: o template se atualiza sozinho.

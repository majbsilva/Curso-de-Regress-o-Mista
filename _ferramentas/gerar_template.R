# =====================================================================
# gerar_template.R
# Gera o TEMPLATE do aluno a partir do .qmd MESTRE (versão completa).
#
# Regra: dentro dos blocos ```{r}```, mantém as linhas de comentário
# (as dicas) e apaga as linhas de código. Fora dos blocos, mantém tudo.
# Assim você edita SÓ o arquivo mestre; o template sai atualizado.
#
# COMO USAR (no Console do RStudio, com o Projeto aberto):
#   source("_ferramentas/gerar_template.R")
#   # um módulo:
#   gerar_template("Módulo 9 - Esferoides/modelo_misto_esferoides.qmd")
#   # ou todos de uma vez:
#   gerar_todos(".")
# =====================================================================

gerar_template <- function(mestre, saida = NULL) {
  linhas <- readLines(mestre, encoding = "UTF-8", warn = FALSE)
  if (is.null(saida)) saida <- sub("\\.qmd$", " — TEMPLATE.qmd", mestre)

  out <- character(0)
  marcas_yaml <- 0      # conta os '---' do cabeçalho
  dentro_chunk_r <- FALSE

  for (l in linhas) {
    t <- trimws(l)

    # --- cabeçalho YAML (entre os dois primeiros '---') ---
    if (t == "---" && marcas_yaml < 2) {
      marcas_yaml <- marcas_yaml + 1
      out <- c(out, l)
      if (marcas_yaml == 2) {
        out <- c(out, "",
          "::: {.callout-important title=\"Template para preencher\"}",
          "Este é o **arquivo do aluno**: os blocos de código estão vazios, com uma dica em cada um. Escreva o código junto com o professor durante a aula.",
          ":::")
      }
      next
    }
    if (marcas_yaml == 1) {                      # ainda dentro do YAML
      if (grepl("^title:", t)) l <- sub("\"\\s*$", " — Template\"", l)
      out <- c(out, l); next
    }

    # --- blocos de código R ---
    if (!dentro_chunk_r && grepl("^```\\{r", t)) { dentro_chunk_r <- TRUE; out <- c(out, l); next }
    if (dentro_chunk_r && grepl("^```\\s*$", t)) { dentro_chunk_r <- FALSE; out <- c(out, l); next }
    if (dentro_chunk_r) {
      manter <- (t == "") ||
                (startsWith(t, "#") && !grepl("code-fold|code-summary", t))
      if (manter) out <- c(out, l)
      next
    }

    # --- fora de chunk: mantém tudo ---
    out <- c(out, l)
  }

  writeLines(out, saida, useBytes = TRUE)
  message("Template gerado: ", saida)
  invisible(saida)
}

# Gera o template de todos os .qmd mestres da pasta (ignora os já '— TEMPLATE')
gerar_todos <- function(pasta = ".") {
  arquivos <- list.files(pasta, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
  arquivos <- arquivos[!grepl("TEMPLATE", arquivos)]
  for (a in arquivos) gerar_template(a)
  invisible(arquivos)
}

# PARA CARREGAR

# source("_ferramentas/gerar_template.R")

# EXEMPLO DE USO. Ele criar automaticamente esse modulo, mas terminando na palavra - TEMPLATE

# gerar_template("Módulo 9 - Esferoides/modelo_misto_esferoides.qmd")

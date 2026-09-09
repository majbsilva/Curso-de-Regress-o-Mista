# PROGRESSO.md

Registro de avanço do curso de Bioestatística em R (foco em regressão mista).

## Status geral

Em desenvolvimento. Estrutura definida: 10 módulos teóricos (1 a 10) + 2 casos práticos (C1, C2).

## Roteiro de módulos

| Módulo | Tópico | Tipo | Status | Arquivo |
|--------|--------|------|--------|---------|
| 1 | Por que usar modelo misto | Teórico | Concluído (mestre + template) | `Módulo 1 - Por que modelo misto/` |
| 2 | Efeito fixo versus aleatório | Teórico | Concluído (mestre + template) | `Módulo 2 - Efeito fixo e aleatorio/` |
| 3 | Quando usar (e quando não) | Teórico | Concluído (mestre + template) | `Módulo 3 - Quando usar/` |
| 4 | Estrutura do modelo | Teórico | Concluído (mestre + template) | `Módulo 4 - Estrutura do modelo/` |
| 5 | Exemplo prático em R (medidas repetidas) | Teórico | Concluído (mestre + template) | `Módulo 5 - Exemplo pratico R/` |
| 6 | Como escolher a estrutura aleatória | Teórico | Concluído (mestre + template) | `Módulo 6 - Estrutura aleatoria/` |
| 7 | Diagnóstico do modelo | Teórico | Concluído (mestre + template) | `Módulo 7 - Diagnostico/` |
| 8 | Modelos mistos estendidos | Teórico | Concluído (mestre + template) | `Módulo 8 - Modelos estendidos/` |
| 9 | Erros frequentes dos iniciantes | Teórico | Concluído (mestre + template) | `Módulo 9 - Erros frequentes/` |
| 10 | Roteiro de exercícios | Teórico | Concluído (mestre + template) | `Módulo 10 - Exercicios/` |
| C1 | Entendendo modelos mistos (sleepstudy) | Caso | Concluído (mestre + template) | `Módulo C1 - sleepstudy/` |
| C2 | Estudo de caso esferoides | Caso | Concluído (mestre + template) | `Módulo C2 - Esferoides/` |

## Detalhe dos casos

### Caso C1 - sleepstudy (intuição)
- Arquivo-mestre: `Módulo C1 - sleepstudy/entendendo_modelos_mistos.qmd`
- Template: `Módulo C1 - sleepstudy/entendendo_modelos_mistos — TEMPLATE.qmd`
- Dataset embutido `sleepstudy` (lme4): 18 sujeitos, 10 dias de privação de sono.
- Sequência: regressão comum vs modelo misto, `(1|Subject)`, `(Days|Subject)`, interpretação, médias ajustadas, diagnóstico, ponte para esferoides.
- Referências: Harrell, Field, Bates et al.

### Caso C2 - esferoides (aplicado)
- Arquivo-mestre: `Módulo C2 - Esferoides/modelo_misto_esferoides.qmd`
- Template: `Módulo C2 - Esferoides/modelo_misto_esferoides — TEMPLATE.qmd`
- Caso de bancada: 8 tratamentos, 2 tempos (0h, 72h), 7 esferoides; escala log, variância heterogênea (`varIdent`), modelo pareado (`gls`), Dunnett exato (`mvt`), três figuras de artigo.

## Ferramentas do curso

- `_ferramentas/gerar_template.R`: gera o template do aluno a partir do mestre (mantém dicas, apaga código).
- Documento de fluxo: `Dinamica_e_Fluxo_de_Arquivos.md`.
- Diretrizes de estilo: `CLAUDE.md`.

## Convenção de numeração

- Teóricos: Módulo 1 a 10 (um por ponto do conteúdo programático).
- Casos: C1 (sleepstudy, intuição) e C2 (esferoides, aplicado). Vieram antes da decisão de numerar teóricos, daí a letra C para não colidir.

## Próximos passos

- Revisar o material com foco em clareza e ausência de jargão.
- Ordenar a sequência de aula: teóricos 1 a 10, intercalando C1 (após o Módulo 4 ou 5) e C2 (após o Módulo 7).
- Produzir a referência HTML de cada mestre via `quarto render`.
- Atualizar este arquivo sempre que um módulo avançar de status.

## Observações

Atualizar este arquivo sempre que um módulo avançar de status. Os templates são gerados a partir dos mestres via `gerar_template()`; não editar os templates diretamente.

# Curso de Bioestatística em R: Modelos Mistos

*Setembro 2026*

Este repositório reúne os materiais do curso de bioestatística em R, com foco em modelos de efeitos fixos e aleatórios (modelos mistos). O curso combina módulos teóricos e casos práticos aplicados em R, pensado para quem precisa analisar dados de estudos e experimentos mas tem pouca familiaridade com estatística e com a linguagem R.

## Objetivos

Ao final do curso, espera-se que as pessoas participantes sejam capazes de:

* entender por que usar um modelo misto e a diferença entre efeito fixo e efeito aleatório;
* reconhecer quando aplicar (e quando não aplicar) um modelo misto;
* estruturar e ajustar modelos mistos em R (`lmer`, `glmer`, `gls`);
* escolher a estrutura de efeitos aleatórios adequada e comparar modelos por AIC/BIC;
* realizar o diagnóstico do modelo (resíduos, convergência, colinearidade);
* aplicar os conceitos a um caso clássico (sleepstudy) e a um caso real de bancada (esferoides).

## Conteúdo programático

### 1. Módulos teóricos

1. Por que usar modelo misto
2. Efeito fixo e efeito aleatório
3. Quando usar (e quando não)
4. Estrutura do modelo
5. Exemplo prático em R (medidas repetidas)
6. Como escolher a estrutura aleatória
7. Diagnóstico do modelo
8. Modelos mistos estendidos (glmer, Poisson, binomial negativa, sobrevida com fragilidade)
9. Erros frequentes dos iniciantes
10. Roteiro de exercícios

### 2. Casos práticos

* **C1, sleepstudy**: intuição com o dataset clássico do pacote `lme4` (18 sujeitos, 10 dias de privação de sono). Liga regressão comum ao modelo misto, `(1 | Subject)` a `(Days | Subject)`.
* **C2, esferoides**: caso de bancada com 8 tratamentos, 2 tempos (0h e 72h) e 7 esferoides por grupo. Escala log, variância heterogênea (`varIdent`), modelo pareado (`gls`) e Dunnett exato.

## Metodologia

Cada módulo teórico tem um arquivo-mestre em Quarto (`.qmd`) com o código completo e um template do aluno (mesmo texto, código em branco com dicas), gerado a partir do mestre pelo script `_ferramentas/gerar_template.R`. Os dois casos práticos seguem a mesma lógica.

## Público-alvo

Alunos de pós-graduação, professores e profissionais da pesquisa que precisam analisar dados de estudos e experimentos, mas frequentemente enfrentam dificuldade com estatística e com a linguagem R.

## Referências-base

* Harrell, F. E. (2015). *Regression Modeling Strategies*. Springer.
* Field, A., Miles, J., e Field, Z. (2012). *Discovering Statistics Using R*. Sage.

## Vinhetas

<!-- Preencher com os links para as páginas HTML depois de publicadas via GitHub Pages, no formato:1. [Módulo 1, Por que modelo misto](https://<usuario>.github.io/<repo>/Modulo1.html)-->

## Ministrante

**Marcelo J. B. Silva**

* Professor Associado IV, Instituto de Ciências Biomédicas (ICBIM), Universidade Federal de Uberlândia (UFU)
* Laboratório NEPON, PPGIPA (Imunologia e Parasitologia Aplicadas)

## Declaração de IA

Ferramentas de inteligência artificial generativa foram utilizadas como apoio na elaboração e revisão de textos, códigos e materiais deste repositório. Todo o conteúdo produzido com esse auxílio foi revisado, adaptado e validado pelo autor, que permanece responsável por sua versão final.

## Licenças

O conteúdo de texto deste curso está disponível sob a licença [Creative Commons Atribuição-NãoComercial 4.0 Internacional (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/deed.pt-br). Os códigos-fonte (scripts e `.qmd`) estão disponíveis sob a licença MIT. Consulte o arquivo [LICENSE.md](LICENSE.md) para os termos aplicáveis. 

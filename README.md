Curso de Bioestatística em R: Modelos Mistos
============================================

_Setembro 2026_

Este repositório reúne os materiais do curso de bioestatística em R, com foco em modelos de efeitos fixos e aleatórios (modelos mistos). O curso combina módulos teóricos e casos práticos aplicados em R, pensado para quem precisa analisar dados de estudos e experimentos mas tem pouca familiaridade com estatística e com a linguagem R.
Objetivos
---------

Ao final do curso, espera-se que as pessoas participantes sejam capazes de:

* entender por que usar um modelo misto e a diferença entre efeito fixo e efeito aleatório;
* reconhecer quando aplicar (e quando não aplicar) um modelo misto;
* estruturar e ajustar modelos mistos em R (`lmer`, `glmer`, `gls`);
* escolher a estrutura de efeitos aleatórios adequada e comparar modelos por AIC/BIC;
* realizar o diagnóstico do modelo (resíduos, convergência, colinearidade);
* aplicar os conceitos a um caso clássico (sleepstudy) e a um caso real de bancada (esferoides).

Conteúdo programático
---------------------

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

Metodologia
-----------

Cada módulo teórico tem um arquivo-mestre em Quarto (`.qmd`) com o código completo e um template do aluno (mesmo texto, código em branco com dicas), gerado a partir do mestre pelo script `_ferramentas/gerar_template.R`. Os dois casos práticos seguem a mesma lógica.
Público-alvo
------------

Alunos de pós-graduação, professores e profissionais da pesquisa que precisam analisar dados de estudos e experimentos, mas frequentemente enfrentam dificuldade com estatística e com a linguagem R.
Referências-base
----------------

* Harrell, F. E. (2015). _Regression Modeling Strategies_. Springer.
* Field, A., Miles, J., e Field, Z. (2012). _Discovering Statistics Using R_. Sage.

Vinhetas
--------

1. [Módulo 1, Por que modelo misto](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_1_Por_que_modelo_misto.html)
2. [Módulo 2, Efeito fixo e aleatório](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_2_Efeito_fixo_e_aleatorio.html)
3. [Módulo 3, Quando usar](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_3_Quando_usar.html)
4. [Módulo 4, Estrutura do modelo](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_4_Estrutura_do_modelo.html)
5. [Módulo 5, Exemplo prático em R](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_5_Exemplo_pratico_R.html)
6. [Módulo 6, Estrutura aleatória](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_6_Estrutura_aleatoria.html)
7. [Módulo 7, Diagnóstico do modelo](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_7_Diagnostico.html)
8. [Módulo 8, Modelos mistos estendidos](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_8_Modelos_estendidos.html)
9. [Módulo 9, Erros frequentes dos iniciantes](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_9_Erros_frequentes.html)
10. [Módulo 10, Roteiro de exercícios](https://majbsilva.github.io/Curso-de-Regress-o-Mista/vinhetas/Modulo_10_Exercicios.html)


-----------

**Marcelo J. B. Silva**

* Professor Associado IV, Instituto de Ciências Biomédicas (ICBIM), Universidade Federal de Uberlândia (UFU)
* Laboratório NEPON, PPGIPA (Imunologia e Parasitologia Aplicadas)

Licenças
----------------

O conteúdo de texto deste curso está disponível sob a licença [Creative Commons Atribuição-NãoComercial 4.0 Internacional (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/deed.pt-br). Os códigos-fonte (scripts e `.qmd`) estão disponíveis sob a licença MIT. Consulte o arquivo [LICENSE.md](https://claude.ai/chat/LICENSE.md) para os termos aplicáveis.

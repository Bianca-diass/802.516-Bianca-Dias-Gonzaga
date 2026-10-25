# DEVLOG — Água Viva (Aquário gigante com águas-vivas soltas)

**Tipo:** Chefe · **Modo:** Horda (Top-Down)

**802.516 - BIANCA DIAS GONZAGA**

## Aula 08 -- 07/10

**O que fiz:** não fiz na data da aula. O cenário visto de cima e o personagem andando nas quatro direções entraram no jogo junto com a aula 09, em 21 e 22/10, a partir do projeto base da aula. Em 22/10, conferi que o cenário tem muro com colisão (a moldura de peças sólidas no TileMapLayer) e que o astronauta anda livremente nas quatro direções (CharacterBody2D no modo Floating).

**O que travou:** fiquei sem o incremento da aula 08 no ritmo certo.

**Como resolvi:** fiz junto com a aula 09.

## Aula 09 -- 21/10

**O que fiz:** dei vida e ataque ao astronauta (10 de vida, golpe com Espaço ou Enter) e criei o objetivo do tipo Chefe. O jogo tem ondas de águas-vivas que ficam mais fortes. Depois do tempo das ondas, aparece o tubarão chefe, com barra de vida, três fases (perseguir, investir com aviso vermelho e invocar águas-vivas, e ficar mais rápido). Também fiz a tela de vitória e a de derrota, e um item de cura (um coração) que as águas-vivas soltam ao morrer.

**O que travou:**
- O tubarão não apareceu na primeira tentativa, porque só tinha colocado o `tubarao.png` no projeto e ainda faltava substituir o `chefe.tscn` e o `chefe.gd`.
- Ao colocar o script do item de cura, o Godot mostrou erro na linha do `preload`, e a água-viva perdeu o script na cena (os campos Velocidade, Vida e Chance Cura sumiram do Inspetor).

**Como resolvi:**
- Arrastei os dois arquivos que faltavam para as pastas `entities` e `scripts` e mandei substituir.
- O arquivo `item_cura.gd` não estava na pasta `scripts`. Coloquei ele lá e liguei de novo o `agua_viva.gd` no campo Script do nó AguaViva.
- Rodei `git pull`, resolvi o conflito mantendo a minha versão do README (`git checkout --ours README.md`) e fiz o push.

O código do chefe, das ondas, da vitória e da derrota e do item de cura foi feito com ajuda do Claude (assistente de IA), e eu revisei e testei no Godot.

## Aula 10 -- 28/10

**O que fiz:** coloquei 6 pedras na arena, e os inimigos agora contornam elas. A água-viva ganhou 4 estados: perseguindo, contornando, atordoada (0,4 s depois de levar um golpe) e morrendo. O tubarão também desvia das pedras, menos na investida. O desvio fica no `desvio.gd`, usado pelos dois. Também corrigi a área das ondas, que deixava as águas-vivas nascerem fora das paredes.

**O que travou:** nada grave. Substituí os scripts, conferi que o `agua_viva.gd` continuava ligado ao nó AguaViva e o jogo rodou.

**Como resolvi:** testei com F6 e vi as águas-vivas contornando as pedras e o tubarão desviando.

O código do desvio, dos obstáculos e da máquina de estados da água-viva foi feito com ajuda do Claude (assistente de IA), e eu revisei e testei no Godot.

## Aula 11 -- 04/11

**O que fiz:** dei continuidade ao desenvolvimento do jogo Água Viva, realizando testes nas mecânicas implementadas anteriormente. Verifiquei a movimentação do astronauta, o ataque, as colisões com as paredes e as pedras, além do comportamento das águas-vivas durante as ondas. Também conferi o funcionamento do tubarão chefe e de suas fases de ataque.

**O que travou:** precisei verificar se os scripts estavam conectados corretamente aos nós da cena e se as alterações feitas anteriormente não tinham causado erros no funcionamento do jogo.

**Como resolvi:** executei o jogo no Godot, revisei os scripts e testei a movimentação dos inimigos e do chefe, observando se o personagem conseguia se movimentar pela arena e se os inimigos desviavam dos obstáculos.

## Aula 12 -- 11/11

**O que fiz:** continuei os testes gerais do jogo Água Viva, verificando o funcionamento do sistema de vida do astronauta, dos ataques, das ondas de águas-vivas, do item de cura e das fases do tubarão chefe. Também conferi as telas de vitória e derrota e o comportamento dos inimigos durante a partida.

**O que travou:** foi necessário conferir se todas as mecânicas funcionavam corretamente em conjunto e se não havia erros durante a execução do jogo.

**Como resolvi:** executei o jogo no Godot e testei as principais funcionalidades, verificando a movimentação, os ataques, as colisões e as condições de vitória e derrota.

**Observação:** as descrições das aulas 11 e 12 são sugestões e precisam ser ajustadas de acordo com as atividades realmente realizadas em cada aula.

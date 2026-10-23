# Água Viva — Aquário gigante com águas-vivas soltas

**802.516 — Bianca Dias Gonzaga**

- **Tema:** Aquário gigante com águas-vivas soltas
- **Tipo:** Chefe — resistir às ondas até o chefe surgir e derrotá-lo
- **Modo:** 2D, um jogador
- **Repositório:** _(cole aqui o link do GitHub)_

Jogo 2D feito na Godot 4.7 com o renderizador Compatibility. Um astronauta fica preso dentro de um aquário gigante e precisa sobreviver às ondas de águas-vivas. Quando o tempo das ondas acaba, um tubarão gigante aparece, e o astronauta precisa derrotá-lo.

## Como executar

1. Importe o arquivo `project.godot` na Godot 4.7 ou uma versão 4.7 posterior.
2. Abra o projeto e abra a cena `scenes/agua.tscn`.
3. Pressione **F6** para rodar a cena (ou defina `agua.tscn` como cena principal e use **F5**).

## Controles

| Ação | Tecla |
| --- | --- |
| Mover | **WASD** ou **setas** (também na diagonal) |
| Atacar | **Espaço** ou **Enter** |

O ataque acerta todos os inimigos dentro de um círculo ao redor do astronauta e tem um pequeno intervalo entre um golpe e outro.

## Como o jogo funciona

1. **Ondas:** a cada 12 segundos surge uma nova onda de águas-vivas. Cada onda tem mais águas-vivas e elas ficam um pouco mais rápidas. Um contador no topo mostra a onda atual e o tempo até a chegada do chefe.
2. **Chegada do chefe:** quando o tempo acaba, as águas-vivas restantes somem e o tubarão aparece, com uma barra de vida no topo da tela.
3. **Fases do chefe:**
   - **Fase 1 (vida acima de 60%):** o tubarão persegue o astronauta.
   - **Fase 2 (abaixo de 60%):** ele faz investidas e invoca 2 águas-vivas a cada 6 segundos. Antes de investir, ele fica vermelho e para por um instante, e esse é o sinal para desviar.
   - **Fase 3 (abaixo de 30%):** ele fica mais rápido e investe com mais frequência.
4. **Vitória:** ao derrotar o tubarão, aparece "VITÓRIA!" e o jogo reinicia.
5. **Derrota:** se a vida do astronauta chegar a zero, aparece "DERROTA!" e o jogo reinicia.

## Números do jogo

| Elemento | Valor |
| --- | --- |
| Vida do astronauta | 5 (1 segundo de invulnerabilidade após levar dano) |
| Vida da água-viva | 2 |
| Vida do chefe | 25 |
| Duração das ondas | configurável no nó `Ondas` (propriedade **Duracao**) |

Para ajustar a dificuldade, mude **Vida Max** e **Velocidade** no nó `Chefe` (`entities/chefe.tscn`) e **Duracao** e **Intervalo** no nó `Ondas` da cena `agua`.

## Estrutura do projeto

- `scenes/agua.tscn` — cena principal: fundo, jogador e controlador das ondas.
- `entities/jogador.tscn` — astronauta (movimento, ataque, vida e câmera).
- `entities/agua_viva.tscn` — inimigo comum.
- `entities/chefe.tscn` — tubarão (chefe).
- `scripts/jogador.gd`, `scripts/agua_viva.gd`, `scripts/chefe.gd` — comportamento de cada personagem.
- `scripts/ondas.gd` — gera as ondas, chama o chefe e controla a vitória.
- `sprites/` — imagens do jogo.

## Créditos

- Tileset do cenário: Tiny Town, de Kenney (https://kenney.nl/assets/tiny-town), licença CC0.
- Pacote de tiles sazonais: GrafxKid, licença CC0.
- Tubarão, água-viva e astronauta: sprites de pacotes de pixel art gratuitos. _(Complete com o nome do autor e o link de cada pacote.)_
- Imagem de fundo do aquário: gerada com o Gemini.
- Jogo desenvolvido por Bianca Dias Gonzaga, com ajuda do Claude para o código do chefe.

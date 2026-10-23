extends StaticBody2D

# Pedra do aquário: bloqueia o jogador (colisão) e os inimigos a contornam.
# Criada pelo ondas.gd. Código feito com ajuda do Claude (assistente de IA).

@export var raio: float = 18.0

func _ready() -> void:
	add_to_group("obstaculos")
	var forma := CollisionShape2D.new()
	var circulo := CircleShape2D.new()
	circulo.radius = raio
	forma.shape = circulo
	add_child(forma)

func _draw() -> void:
	draw_circle(Vector2(0, 2), raio, Color(0.08, 0.14, 0.2))                       # sombra
	draw_circle(Vector2.ZERO, raio, Color(0.23, 0.33, 0.42))                       # pedra
	draw_circle(Vector2(-raio * 0.25, -raio * 0.3), raio * 0.55, Color(0.33, 0.46, 0.56))
	draw_circle(Vector2(-raio * 0.35, -raio * 0.4), raio * 0.18, Color(0.6, 0.75, 0.85, 0.8))

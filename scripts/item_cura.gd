extends Node2D

# Coração que devolve vida ao jogador. É criado por agua_viva.gd quando ela morre.

@export var cura: int = 1
@export var raio_coleta: float = 14.0
@export var duracao: float = 10.0   # segundos até sumir se ninguém pegar

var tempo := 0.0

func _ready() -> void:
	z_index = 2

func _process(delta: float) -> void:
	tempo += delta
	if tempo >= duracao:
		queue_free()
		return
	# pisca nos últimos 3 segundos
	visible = tempo < duracao - 3.0 or int(tempo * 8.0) % 2 == 0
	queue_redraw()

	var jogador := get_tree().get_first_node_in_group("jogador")
	if jogador != null and global_position.distance_to(jogador.global_position) < raio_coleta:
		if jogador.curar(cura):
			queue_free()

func _draw() -> void:
	var o := sin(tempo * 4.0) * 2.0   # sobe e desce devagar
	var cor := Color(1.0, 0.25, 0.35)
	draw_circle(Vector2(-3.0, -2.0 + o), 3.5, cor)
	draw_circle(Vector2(3.0, -2.0 + o), 3.5, cor)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-6.4, -0.2 + o), Vector2(6.4, -0.2 + o), Vector2(0.0, 7.0 + o)
	]), cor)
	draw_circle(Vector2(-3.0, -3.0 + o), 1.0, Color(1, 1, 1, 0.8))

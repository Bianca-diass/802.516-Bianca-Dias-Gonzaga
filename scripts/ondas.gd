extends Node

signal chefe_chegou

const AGUA_VIVA := preload("res://entities/agua_viva.tscn")
const CHEFE := preload("res://entities/chefe.tscn")
const OBSTACULO := preload("res://scripts/obstaculo.gd")

@export var duracao: float = 60.0      # segundos até o chefe aparecer
@export var intervalo: float = 12.0    # segundos entre uma onda e outra
@export var area := Rect2(24, 24, 528, 272)  # área onde as águas-vivas podem aparecer (dentro das paredes)
@export var raio_obstaculo: float = 18.0
@export var posicoes_obstaculos: Array[Vector2] = [
	Vector2(110, 90), Vector2(470, 90), Vector2(195, 235),
	Vector2(385, 235), Vector2(160, 160), Vector2(420, 160)
]

var tempo := 0.0
var proxima_onda := 0.0
var onda := 0
var acabou := false
var label: Label

func _ready() -> void:
	var camada := CanvasLayer.new()
	label = Label.new()
	label.position = Vector2(8, 40)
	label.add_theme_font_size_override("font_size", 24)
	camada.add_child(label)
	add_child(camada)
	chefe_chegou.connect(_spawnar_chefe)
	_criar_obstaculos()

func _criar_obstaculos() -> void:
	for p in posicoes_obstaculos:
		var o := OBSTACULO.new()
		o.raio = raio_obstaculo
		o.position = p
		get_parent().add_child.call_deferred(o)

func _process(delta: float) -> void:
	if acabou:
		return
	tempo += delta
	if tempo >= proxima_onda and tempo < duracao:
		onda += 1
		proxima_onda += intervalo
		_spawnar_onda()
	label.text = "Onda %d  |  Chefe em %d s" % [onda, int(ceil(duracao - tempo))]
	if tempo >= duracao:
		acabou = true
		label.text = "O CHEFE CHEGOU!"
		chefe_chegou.emit()

func _spawnar_onda() -> void:
	var quantidade := 3 + onda * 2
	for i in quantidade:
		var j = AGUA_VIVA.instantiate()
		j.velocidade += onda * 4.0
		get_parent().add_child(j)
		j.global_position = _ponto_de_spawn()

func _ponto_de_spawn() -> Vector2:
	var centro := area.get_center()
	var jogador := get_tree().get_first_node_in_group("jogador")
	if jogador != null:
		centro = jogador.global_position
	var p := centro + Vector2.from_angle(randf() * TAU) * 220.0
	return Vector2(clampf(p.x, area.position.x, area.end.x), clampf(p.y, area.position.y, area.end.y))

func _spawnar_chefe() -> void:
	# some com as águas-vivas que sobraram
	for e in get_tree().get_nodes_in_group("inimigos"):
		e.queue_free()
	var chefe = CHEFE.instantiate()
	get_parent().add_child(chefe)
	var x := area.get_center().x
	var jogador := get_tree().get_first_node_in_group("jogador")
	if jogador != null:
		x = clampf(jogador.global_position.x, area.position.x + 60.0, area.end.x - 60.0)
	chefe.global_position = Vector2(x, area.position.y + 60.0)
	chefe.morreu.connect(_ao_chefe_morrer.bind(chefe))

func _ao_chefe_morrer(chefe: Node) -> void:
	# some com as águas-vivas invocadas e protege o jogador durante a vitória
	for e in get_tree().get_nodes_in_group("inimigos"):
		if e != chefe:
			e.queue_free()
	var jogador := get_tree().get_first_node_in_group("jogador")
	if jogador != null:
		jogador.invulneravel = true
	label.text = "VITÓRIA! Você derrotou o chefe!"
	await get_tree().create_timer(4.0).timeout
	get_tree().reload_current_scene()

extends Node2D

signal morreu

const FILHA := preload("res://entities/agua_viva.tscn")

@export var vida_max: int = 25
@export var velocidade: float = 30.0
@export var dano: int = 1
@export var raio: float = 38.0

var vida := 0
var morto := false
var alvo: Node2D = null
var recuo := Vector2.ZERO
var tempo_filhas := 4.0
var estado := "normal"
var tempo_estado := 4.0
var dir_investida := Vector2.ZERO
var barra: ProgressBar

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("inimigos")
	vida = vida_max
	anim.play("nadar")
	var camada := CanvasLayer.new()
	barra = ProgressBar.new()
	barra.max_value = vida_max
	barra.value = vida
	barra.show_percentage = false
	barra.custom_minimum_size = Vector2(400, 24)
	camada.add_child(barra)
	add_child(camada)
	barra.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_MINSIZE, 8)

func _fase() -> int:
	var p := float(vida) / float(vida_max)
	if p > 0.6:
		return 1
	if p > 0.3:
		return 2
	return 3

func _physics_process(delta: float) -> void:
	if morto:
		return
	if alvo == null:
		alvo = get_tree().get_first_node_in_group("jogador")
		if alvo == null:
			return

	var fase := _fase()
	var dir := (alvo.global_position - global_position).normalized()
	var vel := velocidade
	if fase == 3:
		vel = velocidade * 1.5

	# Fase 2 e 3: invoca águas-vivas
	if fase >= 2:
		tempo_filhas -= delta
		if tempo_filhas <= 0.0:
			tempo_filhas = 6.0
			_invocar_filhas(2)

		# Investida: avisa (vermelho), para um instante e avança
		tempo_estado -= delta
		if estado == "normal" and tempo_estado <= 0.0:
			estado = "aviso"
			tempo_estado = 0.7
			anim.modulate = Color(1, 0.3, 0.3)
		elif estado == "aviso" and tempo_estado <= 0.0:
			estado = "investida"
			tempo_estado = 0.6
			dir_investida = dir
			anim.modulate = Color.WHITE
		elif estado == "investida" and tempo_estado <= 0.0:
			estado = "normal"
			tempo_estado = 4.0 if fase == 2 else 2.5

	if estado == "aviso":
		vel = 0.0
	elif estado == "investida":
		dir = dir_investida
		vel = 170.0

	# Vira o tubarão na direção do movimento (a imagem original olha para a esquerda)
	if estado != "aviso":
		anim.flip_h = dir.x > 0.0
		var inclinacao := atan2(dir.y, absf(dir.x))
		anim.rotation = inclinacao if dir.x > 0.0 else -inclinacao

	global_position += (dir * vel + recuo) * delta
	recuo = recuo.move_toward(Vector2.ZERO, 200.0 * delta)

	if global_position.distance_to(alvo.global_position) < raio:
		alvo.levar_dano(dano)

func _invocar_filhas(qtd: int) -> void:
	for i in qtd:
		var f = FILHA.instantiate()
		get_parent().add_child(f)
		f.global_position = global_position + Vector2.from_angle(randf() * TAU) * 60.0

func levar_dano(qtd: int, de: Vector2) -> void:
	if morto:
		return
	vida -= qtd
	barra.value = vida
	if vida <= 0:
		morto = true
		morreu.emit()
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property(anim, "modulate:a", 0.0, 1.0)
		t.tween_property(anim, "rotation", PI, 1.0)
		t.chain().tween_callback(queue_free)
		return
	recuo = (global_position - de).normalized() * 40.0
	# pisca branco ao levar dano
	anim.self_modulate = Color(2, 2, 2)
	var t2 := create_tween()
	t2.tween_property(anim, "self_modulate", Color.WHITE, 0.15)

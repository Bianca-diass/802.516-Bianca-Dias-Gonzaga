extends Node2D

signal morreu

const FILHA := preload("res://entities/agua_viva.tscn")

@export var vida_max: int = 20
@export var velocidade: float = 22.0
@export var dano: int = 1
@export var raio: float = 30.0

var vida := 0
var morto := false
var alvo: Node2D = null
var recuo := Vector2.ZERO
var tempo_filhas := 3.0
var estado := "normal"
var tempo_estado := 3.0
var dir_investida := Vector2.ZERO
var cor_original := Color.WHITE
var barra: ProgressBar

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("inimigos")
	vida = vida_max
	cor_original = anim.modulate
	anim.animation_finished.connect(_ao_terminar_animacao)
	anim.play("andar")
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

	# Fase 2 e 3: invoca águas-vivas pequenas
	if fase >= 2:
		tempo_filhas -= delta
		if tempo_filhas <= 0.0:
			tempo_filhas = 5.0
			_invocar_filhas(2)

	# Fase 3: fica mais rápido e faz investidas (com aviso amarelo antes)
	if fase >= 3:
		vel = velocidade * 1.5
		tempo_estado -= delta
		if estado == "normal" and tempo_estado <= 0.0:
			estado = "aviso"
			tempo_estado = 0.7
			anim.modulate = Color(1, 1, 0.3)
		elif estado == "aviso" and tempo_estado <= 0.0:
			estado = "investida"
			tempo_estado = 0.6
			dir_investida = dir
			anim.modulate = cor_original
		elif estado == "investida" and tempo_estado <= 0.0:
			estado = "normal"
			tempo_estado = 3.0

	if estado == "aviso":
		vel = 0.0
	elif estado == "investida":
		dir = dir_investida
		vel = 150.0

	global_position += (dir * vel + recuo) * delta
	recuo = recuo.move_toward(Vector2.ZERO, 200.0 * delta)

	if global_position.distance_to(alvo.global_position) < raio:
		alvo.levar_dano(dano)

func _invocar_filhas(qtd: int) -> void:
	for i in qtd:
		var f = FILHA.instantiate()
		get_parent().add_child(f)
		f.global_position = global_position + Vector2.from_angle(randf() * TAU) * 50.0

func levar_dano(qtd: int, de: Vector2) -> void:
	if morto:
		return
	vida -= qtd
	barra.value = vida
	if vida <= 0:
		morto = true
		anim.modulate = cor_original
		anim.play("morte")
		morreu.emit()
		return
	recuo = (global_position - de).normalized() * 40.0
	anim.play("dano")

func _ao_terminar_animacao() -> void:
	if morto:
		queue_free()
	else:
		anim.play("andar")

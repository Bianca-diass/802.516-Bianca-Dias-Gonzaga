extends Node2D

# Água-viva com máquina de estados: PERSEGUINDO, CONTORNANDO, ATORDOADO e MORRENDO.
# Código feito com ajuda do Claude (assistente de IA).

const ITEM_CURA := preload("res://scripts/item_cura.gd")
const DESVIO := preload("res://scripts/desvio.gd")

enum Estado { PERSEGUINDO, CONTORNANDO, ATORDOADO, MORRENDO }

@export var velocidade: float = 35.0
@export var vida: int = 2
@export var dano: int = 1
@export var chance_cura: float = 0.25    # 0.25 = 25% de soltar um coração
@export var raio_corpo: float = 8.0
@export var tempo_atordoado: float = 0.4

var estado: Estado = Estado.PERSEGUINDO
var tempo_estado := 0.0
var alvo: Node2D = null
var recuo := Vector2.ZERO

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("inimigos")
	anim.animation_finished.connect(_ao_terminar_animacao)
	anim.play("andar")

func _physics_process(delta: float) -> void:
	if estado == Estado.MORRENDO:
		return
	if alvo == null:
		alvo = get_tree().get_first_node_in_group("jogador")
		if alvo == null:
			return

	# ATORDOADO: leva o golpe, é empurrada para trás e não ataca
	if estado == Estado.ATORDOADO:
		tempo_estado -= delta
		global_position += recuo * delta
		recuo = recuo.move_toward(Vector2.ZERO, 300.0 * delta)
		DESVIO.empurrar_para_fora(self, raio_corpo)
		if tempo_estado <= 0.0:
			estado = Estado.PERSEGUINDO
		return

	# PERSEGUINDO ou CONTORNANDO: vai em direção ao astronauta, desviando das pedras
	var direcao := (alvo.global_position - global_position).normalized()
	var nova := DESVIO.dirigir(self, direcao, raio_corpo)
	if nova.dot(direcao) < 0.98:
		estado = Estado.CONTORNANDO
	else:
		estado = Estado.PERSEGUINDO
	global_position += (nova * velocidade + recuo) * delta
	recuo = recuo.move_toward(Vector2.ZERO, 300.0 * delta)
	DESVIO.empurrar_para_fora(self, raio_corpo)
	if global_position.distance_to(alvo.global_position) < 14.0:
		alvo.levar_dano(dano)

func levar_dano(qtd: int, de: Vector2) -> void:
	if estado == Estado.MORRENDO:
		return
	vida -= qtd
	if vida <= 0:
		estado = Estado.MORRENDO
		anim.play("morte")
		_soltar_item()
		return
	recuo = (global_position - de).normalized() * 120.0
	estado = Estado.ATORDOADO
	tempo_estado = tempo_atordoado
	anim.play("dano")

func _ao_terminar_animacao() -> void:
	if estado == Estado.MORRENDO:
		queue_free()
	else:
		anim.play("andar")

func _soltar_item() -> void:
	if randf() > chance_cura:
		return
	var item := Node2D.new()
	item.set_script(ITEM_CURA)
	get_parent().add_child(item)
	item.global_position = global_position

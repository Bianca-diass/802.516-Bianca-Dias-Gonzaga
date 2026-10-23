extends Node2D

const ITEM_CURA := preload("res://scripts/item_cura.gd")

@export var chance_cura: float = 0.25   # 0.25 = 25% de soltar um coração

@export var velocidade: float = 35.0
@export var vida: int = 2
@export var dano: int = 1

var alvo: Node2D = null
var morto := false
var recuo := Vector2.ZERO

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("inimigos")
	anim.animation_finished.connect(_ao_terminar_animacao)
	anim.play("andar")

func _physics_process(delta: float) -> void:
	if morto:
		return
	if alvo == null:
		alvo = get_tree().get_first_node_in_group("jogador")
		if alvo == null:
			return
	var direcao := (alvo.global_position - global_position).normalized()
	global_position += (direcao * velocidade + recuo) * delta
	recuo = recuo.move_toward(Vector2.ZERO, 300.0 * delta)
	if global_position.distance_to(alvo.global_position) < 14.0:
		alvo.levar_dano(dano)

func levar_dano(qtd: int, de: Vector2) -> void:
	if morto:
		return
	vida -= qtd
	if vida <= 0:
		morto = true
		anim.play("morte")
		_soltar_item()
		return
	recuo = (global_position - de).normalized() * 120.0
	anim.play("dano")

func _ao_terminar_animacao() -> void:
	if morto:
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

extends CharacterBody2D

@export var velocidade: float = 70.0
@export var vida_max: int = 5
@export var alcance_ataque: float = 45.0
@export var dano_ataque: int = 1

var vida := 0
var invulneravel := false
var atacando := false
var pode_atacar := true
var cor_original := Color.WHITE
var hud: Label

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("jogador")
	vida = vida_max
	cor_original = anim.modulate
	var camada := CanvasLayer.new()
	hud = Label.new()
	hud.position = Vector2(8, 8)
	hud.add_theme_font_size_override("font_size", 24)
	camada.add_child(hud)
	add_child(camada)
	_atualizar_hud()

func _physics_process(_delta: float) -> void:
	var direcao := Input.get_vector("left", "right", "up", "down")
	velocity = direcao * velocidade
	move_and_slide()

	if direcao == Vector2.ZERO:
		if anim.sprite_frames.has_animation("parado"):
			anim.play("parado")
		else:
			anim.stop()
	else:
		anim.play("andar")
		if direcao.x != 0:
			anim.flip_h = direcao.x < 0

	if Input.is_action_just_pressed("ui_accept") and pode_atacar:
		_atacar()

func _atacar() -> void:
	pode_atacar = false
	atacando = true
	queue_redraw()
	for inimigo in get_tree().get_nodes_in_group("inimigos"):
		var extra = inimigo.get("raio")
		if extra == null:
			extra = 0.0
		if global_position.distance_to(inimigo.global_position) <= alcance_ataque + extra:
			inimigo.levar_dano(dano_ataque, global_position)
	await get_tree().create_timer(0.15).timeout
	atacando = false
	queue_redraw()
	await get_tree().create_timer(0.35).timeout
	pode_atacar = true

func _draw() -> void:
	if atacando:
		draw_arc(Vector2.ZERO, alcance_ataque, 0.0, TAU, 48, Color(0.6, 0.9, 1.0, 0.9), 2.0)

func levar_dano(qtd: int) -> void:
	if invulneravel:
		return
	vida -= qtd
	_atualizar_hud()
	invulneravel = true
	anim.modulate = Color(1, 0.3, 0.3)
	if vida <= 0:
		get_tree().reload_current_scene()
		return
	await get_tree().create_timer(1.0).timeout
	anim.modulate = cor_original
	invulneravel = false

func _atualizar_hud() -> void:
	hud.text = "Vida: %d/%d" % [vida, vida_max]

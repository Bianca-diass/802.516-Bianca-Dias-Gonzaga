extends RefCounted

# Ajuda os inimigos a contornarem os obstáculos (nós do grupo "obstaculos").
# Código feito com ajuda do Claude (assistente de IA).

# Guarda a lista de pedras uma vez por quadro de física, em vez de procurar no grupo
# a cada inimigo (isso ajuda o jogo a aguentar a horda cheia).
static var _cache: Array = []
static var _quadro := -1

static func _pedras(no: Node) -> Array:
	var q := Engine.get_physics_frames()
	if q != _quadro:
		_quadro = q
		_cache = no.get_tree().get_nodes_in_group("obstaculos")
	return _cache

# Recebe a direção desejada e devolve uma direção que desvia das pedras à frente.
static func dirigir(no: Node2D, dir: Vector2, raio_corpo: float, antecedencia: float = 50.0) -> Vector2:
	var resultado := dir
	var perp := Vector2(-dir.y, dir.x)   # direção para o lado
	for o in _pedras(no):
		var para_o: Vector2 = o.global_position - no.global_position
		var dist := para_o.length()
		var limite: float = o.raio + raio_corpo
		if dist > limite + antecedencia:
			continue                       # longe demais
		if para_o.dot(dir) <= 0.0:
			continue                       # a pedra está atrás
		if absf(para_o.dot(perp)) >= limite:
			continue                       # a pedra não está no caminho
		var peso := 1.0 - clampf((dist - limite) / antecedencia, 0.0, 1.0)
		var lado := -1.0 if para_o.dot(perp) > 0.0 else 1.0
		resultado += perp * lado * peso * 3.0
	return resultado.normalized()

# Se o inimigo acabou dentro de uma pedra, empurra ele para fora.
static func empurrar_para_fora(no: Node2D, raio_corpo: float) -> void:
	for o in _pedras(no):
		var d: Vector2 = no.global_position - o.global_position
		var limite: float = o.raio + raio_corpo
		if d.length() < limite:
			if d == Vector2.ZERO:
				d = Vector2.RIGHT
			no.global_position = o.global_position + d.normalized() * limite

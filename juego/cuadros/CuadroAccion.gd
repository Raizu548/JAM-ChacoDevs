class_name CuadroAccion
extends Node2D

export(String, "espada", "bomba","calavera", "diamante") var tipo setget ,get_tipo

var mi_pos: Vector2 = Vector2.ZERO

func get_tipo() -> String:
	return tipo

func _ready() -> void:
	global_position = mi_pos
	
	if tipo == "espada":
		$SpriteEspada.visible = true
	elif tipo == "bomba":
		$SpriteBomba.visible = true
	elif tipo == "calavera":
		$SpriteCalavera.visible = true
	else:
		$SpriteDiamante.visible = true
	

func crear(pos: Vector2, tipo_cuadro: String):
	mi_pos = pos
	tipo = tipo_cuadro


func agrandar(tam: float) -> void:
	scale.x = tam
	scale.y = tam

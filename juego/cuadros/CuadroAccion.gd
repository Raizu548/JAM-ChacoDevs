class_name CuadroAccion
extends Node2D

export(String, "espada", "bomba") var tipo setget ,get_tipo

onready var iconEspada = $SpriteEspada
onready var iconBomba = $SpriteBomba

var mi_pos: Vector2 = Vector2.ZERO

func get_tipo() -> String:
	return tipo

func _ready() -> void:
	global_position = mi_pos
	
	if tipo == "espada":
		iconEspada.visible = true
		print("espada")
	elif tipo == "bomba":
		iconBomba.visible = true
		print("bomba")
	

func crear(pos: Vector2, tipo_cuadro: String):
	mi_pos = pos
	tipo = tipo_cuadro

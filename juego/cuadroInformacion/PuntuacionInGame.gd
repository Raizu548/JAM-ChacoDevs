class_name PuntuacionInGame
extends Node2D

onready var labelPuntuacion = $LabelPuntuacion
var puntuacion: int = 0


func _process(delta: float) -> void:
	labelPuntuacion.text = "{pts}".format({"pts":puntuacion})


func agregarPunto(bonus: int) -> void:
	puntuacion += bonus

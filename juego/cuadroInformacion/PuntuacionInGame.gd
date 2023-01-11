class_name PuntuacionInGame
extends Node2D

onready var labelPuntuacion = $LabelPuntuacion
var puntuacion: int = 0

func _ready() -> void:
	Evento.connect("guardar_puntos",self,"_on_guardar_puntos")


func _process(delta: float) -> void:
	labelPuntuacion.text = "{pts}".format({"pts":puntuacion})


func agregarPunto(bonus: int) -> void:
	puntuacion += bonus


func _on_guardar_puntos() -> void:
	DatosJuego.puntosTotal += puntuacion
	Evento.emit_signal("derrota", puntuacion)

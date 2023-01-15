class_name PuntuacionInGame
extends Node2D

onready var labelPuntuacion = $LabelPuntuacion
onready var Animacion = $AnimationPlayer
var puntuacion: int = 0

func _ready() -> void:
	Evento.connect("guardar_puntos",self,"_on_guardar_puntos")


func _process(delta: float) -> void:
	labelPuntuacion.text = "{pts}".format({"pts":puntuacion})


func agregarPunto(bonus: int) -> void:
	puntuacion += bonus
	Animacion.play("agregar")
	

func _on_guardar_puntos() -> void:
#	DatosJuego.puntosTotal += puntuacion
	if puntuacion > DatosJuego.puntMasAlta:
		DatosJuego.puntMasAlta = puntuacion
	Evento.emit_signal("derrota", puntuacion)

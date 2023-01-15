extends Node2D

func _ready() -> void:
	$LabelPuntuacion.text = "{pts}".format({"pts":DatosJuego.puntMasAlta})

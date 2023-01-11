extends Node2D

func _ready() -> void:
	$LabelPts.text = "{pts}".format({"pts":DatosJuego.puntosTotal})

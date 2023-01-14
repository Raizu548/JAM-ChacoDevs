extends Node2D

func _ready() -> void:
	actualizar_panel()


func actualizar_panel() -> void:
	$LabelPts.text = "{pts}".format({"pts":DatosJuego.puntosTotal})

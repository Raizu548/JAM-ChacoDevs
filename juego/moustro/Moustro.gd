class_name Moustro
extends Node2D

onready var labelBonus = $LabelBonus

var bonus: int
var arrayBonus = [1,2,3,4]

func _ready() -> void:
	bonus = arrayBonus[DatosJuego.nivel]
	labelBonus.text = "+{bonus}".format({"bonus":bonus})
	

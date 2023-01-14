class_name Moustro
extends Node2D

onready var labelBonus = $LabelBonus

var bonus: int
var arrayBonus = [1,3,5,7]

func _ready() -> void:
	cambiar_skin()
	

func cambiar_skin() -> void:
	bonus = arrayBonus[DatosJuego.nivel-1]
	labelBonus.text = "+{bonus}".format({"bonus":bonus})
	match DatosJuego.nivel:
		1: 
			$SpriteNivel1.visible = true
			$SpriteNivel2.visible = false
			$SpriteNivel3.visible = false
		2:
			$SpriteNivel1.visible = false
			$SpriteNivel2.visible = true
			$SpriteNivel3.visible = false
		3: 
			$SpriteNivel1.visible = false
			$SpriteNivel2.visible = true
			$SpriteNivel3.visible = false

class_name BotonFlecha
extends Node2D

onready var animacion = $AnimationPlayer
onready var pulsacionSFX = $sonidoSFX


func esPresionado() -> void:
	animacion.play("presionado")
	pulsacionSFX.play()


func _on_Button_pressed() -> void:
	esPresionado()

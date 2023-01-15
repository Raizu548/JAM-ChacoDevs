class_name BotonFlecha
extends Node2D

onready var animacion = $AnimationPlayer
onready var pulsacionSFX = $sonidoSFX

var presionado = false setget setPresionado, getPresionado


func getPresionado() -> bool:
	return presionado

func setPresionado(valor: bool) -> void:
	presionado = valor 

func esPresionado() -> void:
	animacion.play("presionado")
	pulsacionSFX.play()


func _on_Button_pressed() -> void:
	presionado = true
	print("presionado")
	esPresionado()

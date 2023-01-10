class_name BotonFlecha
extends Node2D

onready var animacion = $AnimationPlayer


func esPresionado() -> void:
	animacion.play("presionado")

func _on_Button_pressed() -> void:
	esPresionado()

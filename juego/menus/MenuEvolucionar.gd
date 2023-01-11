extends Control

export(String, FILE, "*.tscn") var menu_principal = ""


func _on_BotonEvolucionar_pressed() -> void:
	pass # Replace with function body.


func _on_BotonAtras_pressed() -> void:
	get_tree().change_scene(menu_principal)

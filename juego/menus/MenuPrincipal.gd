extends Control

export(String, FILE, "*.tscn") var juego = ""
export(String, FILE, "*.tscn") var menu_evolucion = ""


func _on_BotonJugar_pressed() -> void:
	get_tree().change_scene(juego)


func _on_BotonEvolucionar_pressed() -> void:
	pass # Replace with function body.

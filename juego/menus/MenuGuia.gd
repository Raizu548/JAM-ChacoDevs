extends Panel

func _ready() -> void:
	pass


func _on_BotonContinuar_pressed() -> void:
	get_tree().paused = not get_tree().paused
	visible = false

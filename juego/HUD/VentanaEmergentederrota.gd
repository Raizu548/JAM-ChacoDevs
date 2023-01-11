class_name VentanaEmergenteDerrota
extends Panel


export(String, FILE, "*.tscn") var menu_principal = ""


func _ready() -> void:
	Evento.connect("derrota",self,"_on_mostrar_ventana")


func _on_mostrar_ventana(pts: int) -> void:
	visible = true
	get_tree().paused = not get_tree().paused
	$LabelPts.text = "{pts}".format({"pts":pts})


func _on_BotonAceptar_pressed() -> void:
	get_tree().change_scene(menu_principal)

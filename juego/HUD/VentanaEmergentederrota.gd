class_name VentanaEmergenteDerrota
extends Panel

export(String, FILE, "*.tscn") var menu_principal = ""

var puntaje: int


func _ready() -> void:
	Evento.connect("derrota",self,"_on_mostrar_ventana")
	
		
func disminuir() -> void:
	puntaje = puntaje / 2
	$LabelPts.text = "{pts}".format({"pts":puntaje})
	DatosJuego.puntosTotal += puntaje


func _on_mostrar_ventana(pts: int) -> void:
	visible = true
	get_tree().paused = not get_tree().paused
	puntaje = pts
	$LabelPts.text = "{pts}".format({"pts":puntaje})
	
	if DatosJuego.tipo_muerte == "calavera":
		$SpriteTiempo.visible = false
		$SpriteCalavera.visible = true
		$LabelMuerte.text = "¡Moriste!"
		$AnimationPlayer.play("disminuir_recompensa")
	else:
		$SpriteTiempo.visible = true
		$SpriteCalavera.visible = false
		$LabelMuerte.text = "¡Se acabo el tiempo!"
		$LabelPts.text = "{pts}".format({"pts":puntaje})
		DatosJuego.puntosTotal += puntaje
	
	


func _on_BotonAceptar_pressed() -> void:
	get_tree().change_scene(menu_principal)
	get_tree().paused = not get_tree().paused


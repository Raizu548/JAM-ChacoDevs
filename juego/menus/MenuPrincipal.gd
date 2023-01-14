extends Control

export(String, FILE, "*.tscn") var juego = ""
export(String, FILE, "*.tscn") var menu_evolucion = ""

onready var labelPtsEvolucion = $LabelPuntEvolucionar
onready var moustro = $Moustro


func _ready() -> void:
	labelPtsEvolucion.text = "{pts}".format({"pts":DatosJuego.array_pts_evolucion[DatosJuego.nivel-1]})


func _on_BotonJugar_pressed() -> void:
	get_tree().change_scene(juego)


func _on_BotonEvolucionar_pressed() -> void:
	if DatosJuego.puede_evolucionar():
		DatosJuego.evolucionar()
		moustro.cambiar_skin()
		labelPtsEvolucion.text = "{pts}".format({"pts":DatosJuego.array_pts_evolucion[DatosJuego.nivel-1]})
		$PanelPuntuacion.actualizar_panel()

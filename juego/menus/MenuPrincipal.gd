extends Control

export(String, FILE, "*.tscn") var juego = ""
export(String, FILE, "*.tscn") var menu_evolucion = ""

onready var labelPtsEvolucion = $LabelPuntEvolucionar
onready var moustro = $Moustro
onready var botonEvolucionar = $BotonEvolucionar


func _ready() -> void:
	actualizar()


func actualizar() -> void:
	if DatosJuego.puede_evolucionar():
		botonEvolucionar.disabled = false
	else:
		botonEvolucionar.disabled = true
		
	if not DatosJuego.ultimo_nivel():
		labelPtsEvolucion.text = "{pts}".format({"pts":DatosJuego.array_pts_evolucion[DatosJuego.nivel-1]})
	else:
		labelPtsEvolucion.text = "Nivel Maximo!"
		botonEvolucionar.disabled = true


func _on_BotonJugar_pressed() -> void:
	get_tree().change_scene(juego)


func _on_BotonEvolucionar_pressed() -> void:
	if DatosJuego.puede_evolucionar():
		DatosJuego.evolucionar()
		$AnimationPlayer.play("evolucionar")
		labelPtsEvolucion.text = "{pts}".format({"pts":DatosJuego.array_pts_evolucion[DatosJuego.nivel-1]})
		$PanelPuntuacion.actualizar_panel()
		actualizar()

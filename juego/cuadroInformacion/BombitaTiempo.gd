extends Node2D

export var tiempoMax: float

onready var barraTiempo = $ProgressBar
onready var tiempo = $Timer

var tiempoActual
var activado = false


func _ready() -> void:
	visible = false
	barraTiempo.max_value = tiempoMax
	tiempoActual = tiempoMax
	barraTiempo.value = tiempoActual
	tiempo.wait_time = tiempoMax


func _process(delta: float) -> void:
	if activado:
		visible = true
		tiempoActual -= 1 * delta
		barraTiempo.value = tiempoActual
		
		if tiempoActual <= 0:
			activado = false
			visible = false
			tiempoActual = tiempoMax
			barraTiempo.max_value = tiempoActual
			

func activar_tiempo() -> void:
	activado = true
	tiempo.start()


func _on_Timer_timeout() -> void:
	Evento.emit_signal("descongelar")

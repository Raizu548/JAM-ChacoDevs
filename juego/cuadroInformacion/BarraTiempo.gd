extends Node2D

export var tiempoMax: float
export var tiempoDisminuido: float

onready var barraTiempo = $ProgressBar

var tiempoSeg: float
var arrancar: bool = false 


func _ready() -> void:
	tiempoSeg = tiempoMax
	barraTiempo.max_value = tiempoMax
	barraTiempo.value = tiempoSeg


func _process(delta: float) -> void:
	if arrancar:
		tiempoSeg -= 1 * delta
		barraTiempo.value = tiempoSeg

		if tiempoSeg <= 0:
			set_process(false)
			Evento.emit_signal("guardar_puntos")


func comenzar() -> void:
	arrancar = true


func resetear_tiempo() -> void:
	tiempoSeg = tiempoMax


func disminuir_tiempo() -> void:
	tiempoSeg -= tiempoDisminuido

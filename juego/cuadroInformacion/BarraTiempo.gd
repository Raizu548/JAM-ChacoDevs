extends Node2D

export var tiempoMax: float
export var tiempoDisminuido: float

onready var barraTiempo = $ProgressBar

var tiempoSeg: float


func _ready() -> void:
	tiempoSeg = tiempoMax
	barraTiempo.max_value = tiempoMax
	barraTiempo.value = tiempoSeg


func _process(delta: float) -> void:
	tiempoSeg -= 1 * delta
	barraTiempo.value = tiempoSeg

	if tiempoSeg <= 0:
		print("Perdiste")
		set_process(false)


func resetear_tiempo() -> void:
	tiempoSeg = tiempoMax


func disminuir_tiempo() -> void:
	tiempoSeg -= tiempoDisminuido

extends Node2D

export var tiempoMax: float
export var tiempoMaxMin: float
export var tiempoMaxActual: float
export var tiempoDisminuido: float
export var tiempoAumentado: float
export var valorDisminusionTiempoMax: float

onready var barraTiempo = $ProgressBar
onready var timerDisminucion = $Timer

var tiempoSeg: float
var arrancar: bool = false 


func _ready() -> void:
	tiempoMaxActual = tiempoMax
	tiempoSeg = tiempoMaxActual
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


func matar_tiempo() -> void:
	tiempoSeg = 0.1


func aumentar_tiempo() -> void:
	if tiempoSeg <= tiempoMaxActual - tiempoAumentado:
		tiempoSeg += tiempoAumentado
		clamp(tiempoSeg,0,tiempoMax)


func disminuir_tiempo() -> void:
	tiempoSeg -= tiempoDisminuido


func disminuir_tiempo_max() -> void:
	if tiempoMaxActual > tiempoMaxMin:
		tiempoMaxActual -= valorDisminusionTiempoMax
		barraTiempo.max_value = tiempoMaxActual

func _on_Timer_timeout() -> void:
	disminuir_tiempo_max()
	print("tiempo disminuido")

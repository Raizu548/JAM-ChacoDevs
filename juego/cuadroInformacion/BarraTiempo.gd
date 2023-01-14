extends Node2D

export var tiempoMax: float
#export var tiempoMaxMin: float
#export var tiempoMaxActual: float
#export var tiempoDisminuido: float
export var tiempoAumentado: float
#export var valorDisminusionTiempoMax: float
export var aumentoVelocidad: float

onready var barraTiempo = $ProgressBar
onready var timerDisminucion = $Timer

var tiempoSeg: float
var arrancar: bool = false 
var aceleracion: float


func _ready() -> void:
	aceleracion = 1
	tiempoSeg = tiempoMax
	barraTiempo.max_value = tiempoMax
	barraTiempo.value = tiempoSeg


func _process(delta: float) -> void:
	if arrancar:
		tiempoSeg -= 1 * delta * aceleracion
		barraTiempo.value = tiempoSeg

		if tiempoSeg <= 0:
			set_process(false)
			Evento.emit_signal("guardar_puntos")


func comenzar() -> void:
	arrancar = true



func matar_tiempo() -> void:
	tiempoSeg = 0.1


func aumentar_velocidad() -> void:
	if aceleracion < 1.6:
		aceleracion += aumentoVelocidad


func aumentar_tiempo() -> void:
	if tiempoSeg <= tiempoMax - tiempoAumentado:
		tiempoSeg += tiempoAumentado
		clamp(tiempoSeg,0,tiempoMax)


func _on_Timer_timeout() -> void:
	aumentar_velocidad()

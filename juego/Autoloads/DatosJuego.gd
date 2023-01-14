extends Node

var nivel: int
var puntosTotal: int
var array_pts_evolucion = [200, 600, 1000, 100000]
var arrat_bonus_nivel = [1, 3]
var tipo_muerte: String


func _ready() -> void:
	nivel = 1
	puntosTotal = 0


func puede_evolucionar() -> bool:
	print("Puntos totales: ", puntosTotal, " - coste evolucion: ", array_pts_evolucion[nivel-1])
	return puntosTotal >= array_pts_evolucion[nivel-1]

func evolucionar() -> void:
	puntosTotal -= array_pts_evolucion[nivel-1]
	nivel += 1

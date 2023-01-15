extends Node

var nivel: int
var puntosTotal: int
var puntMasAlta: int = 0
var array_pts_evolucion = [300, 1000, 1900, 999999]
var arrat_bonus_nivel = [1, 3]
var tipo_muerte: String
var maximoNivel = 4
var primera_partida: bool


func _ready() -> void:
	nivel = 1
	puntosTotal = 0
	primera_partida = true


func puede_evolucionar() -> bool:
	return puntosTotal >= array_pts_evolucion[nivel-1]


func evolucionar() -> void:
	if not ultimo_nivel():
		puntosTotal -= array_pts_evolucion[nivel-1]
		nivel += 1


func ultimo_nivel() -> bool:
	return nivel == maximoNivel

extends Node2D

export var cuadroAccion: PackedScene

onready var botonDer = $BotonDer
onready var botonIzq = $BotonIzq
onready var contPosIzq = $ConPosIzq
onready var contPosDer = $ConPosDer
onready var posFueraDer = $PositionFueraDer
onready var posFueraIzq = $PositionFueraIzq
onready var tween = $Tween

var tamano = 1.6

func _ready() -> void:
	var posiciones = contPosIzq.get_child_count()
	
	for i in range(posiciones):
		var tipo_izq = seleccionar_tipo()
		var nuevo_cuadro_izq = cuadroAccion.instance()
		var nuevo_cuadro_der = cuadroAccion.instance()
		
		if tipo_izq == "espada":
			nuevo_cuadro_izq.crear(contPosIzq.get_child(i).global_position, tipo_izq)
			nuevo_cuadro_der.crear(contPosDer.get_child(i).global_position, "bomba")
		else:
			nuevo_cuadro_izq.crear(contPosIzq.get_child(i).global_position, tipo_izq)
			nuevo_cuadro_der.crear(contPosDer.get_child(i).global_position, "espada")
			
		get_node("contenedorIzq").add_child(nuevo_cuadro_izq)
		get_node("contenedorDer").add_child(nuevo_cuadro_der)
	
	agrandar_objeto(get_node("contenedorDer").get_child(0), tamano)
	agrandar_objeto(get_node("contenedorIzq").get_child(0), tamano)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flecha_der"):
		botonDer.esPresionado()
		var objeto: CuadroAccion = get_node("contenedorDer").get_child(0)
		print(objeto.get_tipo())
		print(objeto)
		tween.interpolate_property(objeto,"position",objeto.global_position,posFueraDer.global_position,
		0.2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		
	elif Input.is_action_just_pressed("flecha_izq"):
		botonIzq.esPresionado()
		

func seleccionar_tipo() -> String:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var valor = random.randi_range(1,2)
	if valor == 1:
		return "espada"
	else:
		return "bomba"


func agrandar_objeto(objeto: CuadroAccion, tamano) -> void:
	print(objeto)
	objeto.agrandar(tamano)

extends Node2D

export var cuadroAccion: PackedScene

onready var botonDer = $BotonDer
onready var botonIzq = $BotonIzq
onready var contPosIzq = $ConPosIzq
onready var contPosDer = $ConPosDer
onready var posFueraDer = $PositionFueraDer
onready var posFueraIzq = $PositionFueraIzq
onready var contenedorDer = $contenedorDer
onready var contenedorIzq = $contenedorIzq
onready var tween = $TweenDesplazamiento
onready var tweenDesap = $TweenDesaparecer
onready var timerPulso = $TimerPulsacion

var tamano = 1.6
var puedePulsar = true
var cadenciaPulsacion = 0.2

func _ready() -> void:
	timerPulso.wait_time = cadenciaPulsacion
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
	
	if puedePulsar:
		timerPulso.start()
		if Input.is_action_just_pressed("flecha_der"):
			botonDer.esPresionado()
			var objeto: CuadroAccion = get_node("contenedorDer").get_child(0)
			desaparecer_objeto(objeto,posFueraDer)
			objeto = get_node("contenedorIzq").get_child(0)
			desaparecer_objeto(objeto,posFueraIzq)
		
			bajar_cuadros(contPosDer,contenedorDer)
			bajar_cuadros(contPosIzq,contenedorIzq)
			agrandar_ambos_primero()
			agregar_nuevo_cuadro()
			puedePulsar = false

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
	objeto.agrandar(tamano)


func agrandar_ambos_primero() -> void:
	var objDer = get_node("contenedorDer").get_child(1)
	var objIzq = get_node("contenedorIzq").get_child(1)
	tween.interpolate_property(objDer,"scale",Vector2(1,1), Vector2(tamano,tamano), 0.1,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(objIzq,"scale",Vector2(1,1), Vector2(tamano,tamano), 0.1,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()


func bajar_cuadros(contenedorPos: Node2D, contObj: Node) -> void:
	##var posiciones = contenedorPos.get_child_count() -1
	var posiciones = contObj.get_child_count() -1
	for i in range(posiciones):
		var posAbajo = contenedorPos.get_child(i)
		var objeto = contObj.get_child(i +1)
		tween.interpolate_property(objeto, "position", objeto.global_position, posAbajo.global_position,
		0.1, Tween.TRANS_LINEAR, tween.EASE_IN_OUT)
		tween.start()


func desaparecer_objeto(objeto: CuadroAccion, posFuera) -> void:
	tweenDesap.interpolate_property(objeto,"position",objeto.global_position,posFuera.global_position,
		0.1, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tweenDesap.start()
	#objeto.queue_free()


func agregar_nuevo_cuadro() -> void:
	var tipo_izq = seleccionar_tipo()
	var nuevo_cuadro_izq = cuadroAccion.instance()
	var nuevo_cuadro_der = cuadroAccion.instance()
	var ultimo = contPosDer.get_child_count() -1
	
	if tipo_izq == "espada":
		nuevo_cuadro_izq.crear(contPosIzq.get_child(ultimo).global_position, tipo_izq)
		nuevo_cuadro_der.crear(contPosDer.get_child(ultimo).global_position, "bomba")
	else:
		nuevo_cuadro_izq.crear(contPosIzq.get_child(ultimo).global_position, tipo_izq)
		nuevo_cuadro_der.crear(contPosDer.get_child(ultimo).global_position, "espada")
	
	get_node("contenedorIzq").add_child(nuevo_cuadro_izq)
	get_node("contenedorDer").add_child(nuevo_cuadro_der)
	

func _on_TweenDesaparecer_tween_completed(object: Object, key: NodePath) -> void:
	object.queue_free()


func _on_TimerPulsacion_timeout() -> void:
	puedePulsar = true

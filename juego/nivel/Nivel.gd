extends Node2D

export var cuadroAccion: PackedScene

onready var botonDer = $BotonDer
onready var botonIzq = $BotonIzq
onready var contPosIzq = $ConPosIzq
onready var contPosDer = $ConPosDer
onready var posFueraDer = $PositionFueraDer
onready var posFueraIzq = $PositionFueraIzq
onready var posCentro = $PositionCentro
onready var contenedorDer = $contenedorDer
onready var contenedorIzq = $contenedorIzq
onready var tween = $TweenDesplazamiento
onready var tweenDesap = $TweenDesaparecer
onready var timerPulso = $TimerPulsacion
onready var contenedorPuntuacion = $PuntuacionInGame
onready var moustroDatos = $Moustro
onready var barraTiempo = $BarraTiempo
onready var bombitaTiempo = $BombitaTiempo
onready var ventanaDerrota = $HUD/VentanaEmergentederrota
onready var ventanaGuia = $HUD/MenuGuia

var tamano = 1.6
var puedePulsar = true
var congelado = false
var cadenciaPulsacion = 0.12
var velocidadAnimacion = 0.1


func _ready() -> void:
	DatosJuego.tipo_muerte = "tiempo"
	Evento.connect("descongelar",self,"_on_descongelar")
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
			nuevo_cuadro_izq.crear(contPosIzq.get_child(i).global_position, "bomba")
			nuevo_cuadro_der.crear(contPosDer.get_child(i).global_position, "espada")
			
		get_node("contenedorIzq").add_child(nuevo_cuadro_izq)
		get_node("contenedorDer").add_child(nuevo_cuadro_der)
	
	agrandar_objeto(get_node("contenedorDer").get_child(0), tamano)
	agrandar_objeto(get_node("contenedorIzq").get_child(0), tamano)


func _process(delta: float) -> void:
	
	if puedePulsar and !congelado:
		timerPulso.start()
		if Input.is_action_just_pressed("flecha_der"):
			barraTiempo.comenzar()
			botonDer.esPresionado()
			var objeto: CuadroAccion = get_node("contenedorDer").get_child(0)
			mover_al_centro(objeto)
			obtenerPunto(objeto)
			objeto = get_node("contenedorIzq").get_child(0)
			desaparecer_objeto(objeto,posFueraIzq)
		
			bajar_cuadros(contPosDer,contenedorDer)
			bajar_cuadros(contPosIzq,contenedorIzq)
			agrandar_ambos_primero()
			agregar_nuevo_cuadro()
			puedePulsar = false

		elif Input.is_action_just_pressed("flecha_izq"):
			barraTiempo.comenzar()
			botonIzq.esPresionado()
			var objeto: CuadroAccion = get_node("contenedorIzq").get_child(0)
			mover_al_centro(objeto)
			obtenerPunto(objeto)
			objeto = get_node("contenedorDer").get_child(0)
			desaparecer_objeto(objeto,posFueraDer)
			
			bajar_cuadros(contPosDer,contenedorDer)
			bajar_cuadros(contPosIzq,contenedorIzq)
			agrandar_ambos_primero()
			agregar_nuevo_cuadro()
			puedePulsar = false
		
	
func seleccionar_tipo() -> String:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var valor = random.randi_range(1,2)
	if valor == 1:
		return "espada"
	else:
		return "bomba"


func seleccionar_segundo_tipo() -> String:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var valor = random.randi_range(1,10)
	if valor == 1:
		return "calavera"
	else:
		return "bomba"


func agrandar_objeto(objeto: CuadroAccion, tamano) -> void:
	objeto.agrandar(tamano)


func agrandar_ambos_primero() -> void:
	var objDer = get_node("contenedorDer").get_child(1)
	var objIzq = get_node("contenedorIzq").get_child(1)
	tween.interpolate_property(objDer,"scale",Vector2(1,1), Vector2(tamano,tamano), velocidadAnimacion,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(objIzq,"scale",Vector2(1,1), Vector2(tamano,tamano), velocidadAnimacion,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()


func bajar_cuadros(contenedorPos: Node2D, contObj: Node) -> void:
	var posiciones = contObj.get_child_count() -1
	for i in range(posiciones):
		var posAbajo = contenedorPos.get_child(i)
		var objeto = contObj.get_child(i +1)
		tween.interpolate_property(objeto, "position", objeto.global_position, posAbajo.global_position,
		velocidadAnimacion, Tween.TRANS_LINEAR, tween.EASE_IN_OUT)
		tween.start()


func desaparecer_objeto(objeto: CuadroAccion, posFuera) -> void:
	tweenDesap.interpolate_property(objeto,"position",objeto.global_position,posFuera.global_position,
		velocidadAnimacion, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tweenDesap.start()


func mover_al_centro(objeto: CuadroAccion) -> void:
	tween.interpolate_property(objeto,"scale",Vector2(tamano,tamano), Vector2(0.2,0.2),
		velocidadAnimacion,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	tweenDesap.interpolate_property(objeto,"position",objeto.global_position, posCentro.global_position,
		velocidadAnimacion, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tweenDesap.start()


func agregar_nuevo_cuadro() -> void:
	var tipo_izq = seleccionar_tipo()
	var nuevo_cuadro_izq = cuadroAccion.instance()
	var nuevo_cuadro_der = cuadroAccion.instance()
	var ultimo = contPosDer.get_child_count() -1
	
	if tipo_izq == "espada":
		nuevo_cuadro_izq.crear(contPosIzq.get_child(ultimo).global_position, "espada")
		nuevo_cuadro_der.crear(contPosDer.get_child(ultimo).global_position, seleccionar_segundo_tipo())
	else:
		nuevo_cuadro_izq.crear(contPosIzq.get_child(ultimo).global_position, seleccionar_segundo_tipo())
		nuevo_cuadro_der.crear(contPosDer.get_child(ultimo).global_position, "espada")
	
	get_node("contenedorIzq").add_child(nuevo_cuadro_izq)
	get_node("contenedorDer").add_child(nuevo_cuadro_der)


func obtenerPunto(objeto: CuadroAccion) -> void:
	if objeto.get_tipo() == "espada":
		contenedorPuntuacion.agregarPunto(moustroDatos.bonus)
		barraTiempo.aumentar_tiempo()
	elif objeto.get_tipo() == "bomba":
		bombitaTiempo.activar_tiempo()
		congelado = true
	else:
		DatosJuego.tipo_muerte = "calavera"
		barraTiempo.matar_tiempo()


func congelar() -> void:
	pass


func _on_TweenDesaparecer_tween_completed(object: Object, key: NodePath) -> void:
	object.queue_free()


func _on_TimerPulsacion_timeout() -> void:
	puedePulsar = true


func _on_descongelar() -> void:
	congelado = false


func _on_BotonPregunta_pressed() -> void:
	ventanaGuia.visible = true
	get_tree().paused = not get_tree().paused

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
onready var barraCombo = $BarraCombo
onready var labelCombo = $LabelCantCombo

onready var SFXboost = $BoostSFX
onready var SFXbomba = $BombaSFX

var tamano = 1.6
var puedePulsar = true
var congelado = false
var cadenciaPulsacion = 0.001 #0.12
var velocidadAnimacion = 0.1
var combo: float = 0
var comboTot: int = 0
var enCombo: bool = false


func _ready() -> void:
	if DatosJuego.primera_partida:
		mostrar_ventana_guia()
		DatosJuego.primera_partida = false
		
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
	
	descontar_combo()
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
			agregar_cuadro()
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
			agregar_cuadro()
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
#	var posiciones = contObj.get_child_count() -1
	var posiciones = 11 # Hard code -> pero sirve
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


func agregar_cuadro() -> void:
	if not enCombo:
		agregar_nuevo_cuadro()
	else:
		agregar_diamantes()


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


func agregar_diamantes() -> void:
	var nuevo_cuadro_izq = cuadroAccion.instance()
	var nuevo_cuadro_der = cuadroAccion.instance()
	var ultimo = contPosDer.get_child_count() -1
	nuevo_cuadro_izq.crear(contPosIzq.get_child(ultimo).global_position, "diamante")
	nuevo_cuadro_der.crear(contPosDer.get_child(ultimo).global_position, "diamante")
	
	get_node("contenedorIzq").add_child(nuevo_cuadro_izq)
	get_node("contenedorDer").add_child(nuevo_cuadro_der)


func convertir_en_diamantes(contenedor: Node, contPos: Node2D) -> void:
	var posiciones = contPos.get_child_count()
	var nombreCont = contenedor.get_name()
	limpiar_contenedor(contenedor)
	for i in range(posiciones):
		var nuevo_cuadro = cuadroAccion.instance()
		nuevo_cuadro.crear(contPos.get_child(i).global_position, "diamante")
		get_node(nombreCont).add_child(nuevo_cuadro)


func limpiar_contenedor(contenedor: Node) -> void:
	var posiciones = contenedor.get_child_count()
	for i in range(posiciones):
		var objeto = contenedor.get_child(i)
		objeto.queue_free()
	

func obtenerPunto(objeto: CuadroAccion) -> void:
	if objeto.get_tipo() == "espada" or objeto.get_tipo() == "diamante":
		contenedorPuntuacion.agregarPunto(moustroDatos.bonus)
		sumar_combo()
		barraTiempo.aumentar_tiempo()
	elif objeto.get_tipo() == "bomba":
		SFXbomba.play()
		bombitaTiempo.activar_tiempo()
		congelado = true
		combo_a_cero()
	else:
		DatosJuego.tipo_muerte = "calavera"
		barraTiempo.matar_tiempo()
		combo_a_cero()


func mostrar_ventana_guia() -> void:
	ventanaGuia.visible = true
	get_tree().paused = not get_tree().paused


func combo_a_cero() -> void:
	combo = 0
	comboTot = 0
	ocultar_combo()


func sumar_combo() -> void:
	if not enCombo:
		combo += 1
		if combo == 100:
			SFXboost.play()
			enCombo = true
			convertir_en_diamantes(contenedorIzq,contPosIzq)
			convertir_en_diamantes(contenedorDer,contPosDer)
			agrandar_ambos_primero()
	comboTot += 1
	actualizar_combo()
	hacer_visible_combo()


func descontar_combo() -> void:
	if enCombo:
		combo -= 0.5
		actualizar_combo()
		if combo <= 0:
			enCombo = false


func ocultar_combo() -> void:
	barraCombo.visible = false
	labelCombo.visible = false
	$LabelTextCombo.visible = false


func hacer_visible_combo() -> void:
	barraCombo.visible = true
	labelCombo.visible = true
	$LabelTextCombo.visible = true


func actualizar_combo() -> void:
	barraCombo.value = combo
	labelCombo.text = "{valor}".format({"valor":comboTot})


func _on_TweenDesaparecer_tween_completed(object: Object, key: NodePath) -> void:
	object.queue_free()


func _on_TimerPulsacion_timeout() -> void:
	puedePulsar = true


func _on_descongelar() -> void:
	congelado = false


func _on_BotonPregunta_pressed() -> void:
	mostrar_ventana_guia()

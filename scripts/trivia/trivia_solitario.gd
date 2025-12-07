extends Control

var preguntas_cultura = [
	{"pregunta":"Â¿CuÃ¡l es la capital de Francia, famosa por la Torre Eiffel?","respuestas":["Madrid","ParÃ­s","Londres","BerlÃ­n"],"correcta":1},
	{"pregunta":"Â¿QuiÃ©n escribiÃ³ 'Don Quijote de la Mancha'?","respuestas":["William Shakespeare","Miguel de Cervantes","Ernest Hemingway","Edgar Allan Poe"],"correcta":1},
	{"pregunta":"Â¿En quÃ© paÃ­s se originÃ³ el Renacimiento?","respuestas":["Italia","Francia","EspaÃ±a","Alemania"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la lengua oficial de Brasil?","respuestas":["PortuguÃ©s","EspaÃ±ol","InglÃ©s","FrancÃ©s"],"correcta":0},
	{"pregunta":"Â¿QuÃ© civilizaciÃ³n construyÃ³ las pirÃ¡mides de Egipto?","respuestas":["Griega","Egipcia","Romana","Maya"],"correcta":1},
	{"pregunta":"Â¿QuiÃ©n pintÃ³ la Mona Lisa?","respuestas":["Vincent van Gogh","Leonardo da Vinci","Pablo Picasso","Claude Monet"],"correcta":1},
	{"pregunta":"Â¿CuÃ¡l es el rÃ­o mÃ¡s largo del mundo?","respuestas":["Nilo","YangtsÃ©","Amazonas","Misisipi"],"correcta":2},
	{"pregunta":"Â¿QuÃ© paÃ­s ganÃ³ la Copa Mundial de FÃºtbol en 2018?","respuestas":["Francia","Brasil","Alemania","Argentina"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n escribiÃ³ 'Romeo y Julieta'?","respuestas":["Miguel de Cervantes","William Shakespeare","Mark Twain","Jane Austen"],"correcta":1},
	{"pregunta":"Â¿CuÃ¡l es la capital de JapÃ³n?","respuestas":["Tokio","Beijing","SeÃºl","Bangkok"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la obra mÃ¡s famosa de Miguel Ãngel?","respuestas":["La Capilla Sixtina","La Ãšltima Cena","Guernica","El Grito"],"correcta":0},
	{"pregunta":"Â¿QuÃ© paÃ­s es conocido como la tierra del sol naciente?","respuestas":["JapÃ³n","China","India","Corea del Sur"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n escribiÃ³ 'Cien aÃ±os de soledad'?","respuestas":["Gabriel GarcÃ­a MÃ¡rquez","Julio CortÃ¡zar","Isabel Allende","Mario Vargas Llosa"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la moneda oficial del Reino Unido?","respuestas":["Libra esterlina","Euro","DÃ³lar","Franco"],"correcta":0},
	{"pregunta":"Â¿QuÃ© ciudad es famosa por el Carnaval y el Cristo Redentor?","respuestas":["RÃ­o de Janeiro","Buenos Aires","Santiago","Lisboa"],"correcta":0},
	{"pregunta":"Â¿En quÃ© aÃ±o cayÃ³ el Imperio Romano de Occidente?","respuestas":["1492","476 d.C.","1066","395 d.C."],"correcta":1},
	{"pregunta":"Â¿QuÃ© filÃ³sofo griego fue maestro de Alejandro Magno?","respuestas":["AristÃ³teles","PlatÃ³n","SÃ³crates","Epicuro"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la capital de CanadÃ¡?","respuestas":["Ottawa","Toronto","Montreal","Vancouver"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n pintÃ³ 'La noche estrellada'?","respuestas":["Pablo Picasso","Vincent van Gogh","Leonardo da Vinci","Salvador DalÃ­"],"correcta":1},
	{"pregunta":"Â¿CuÃ¡l es el continente mÃ¡s grande del mundo?","respuestas":["Asia","Ãfrica","AmÃ©rica","Europa"],"correcta":0},
	{"pregunta":"Â¿En quÃ© paÃ­s estÃ¡ el Taj Mahal?","respuestas":["India","China","PakistÃ¡n","JapÃ³n"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es el idioma mÃ¡s hablado en el mundo?","respuestas":["EspaÃ±ol","InglÃ©s","Chino mandarÃ­n","Hindi"],"correcta":2},
	{"pregunta":"Â¿QuiÃ©n fue el primer presidente de Estados Unidos?","respuestas":["Abraham Lincoln","George Washington","Thomas Jefferson","John Adams"],"correcta":1},
	{"pregunta":"Â¿En quÃ© ciudad se encuentra la estatua de la Libertad?","respuestas":["Nueva York","ParÃ­s","Londres","Washington"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n compuso la Novena SinfonÃ­a?","respuestas":["Mozart","Beethoven","Bach","Chopin"],"correcta":1},
	{"pregunta":"Â¿CuÃ¡l es el paÃ­s mÃ¡s grande del mundo por superficie?","respuestas":["Estados Unidos","CanadÃ¡","China","Rusia"],"correcta":3},
	{"pregunta":"Â¿QuÃ© escritor es conocido por 'El Principito'?","respuestas":["Antoine de Saint-ExupÃ©ry","Gabriel GarcÃ­a MÃ¡rquez","J.K. Rowling","Miguel de Cervantes"],"correcta":0},
	{"pregunta":"Â¿En quÃ© continente estÃ¡ Egipto?","respuestas":["Ãfrica","Asia","Europa","AmÃ©rica"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es el ocÃ©ano mÃ¡s grande del mundo?","respuestas":["AtlÃ¡ntico","PacÃ­fico","Ãndico","Ãrtico"],"correcta":1},
	{"pregunta":"Â¿QuiÃ©n descubriÃ³ AmÃ©rica?","respuestas":["CristÃ³bal ColÃ³n","Marco Polo","AmÃ©rico Vespucio","Fernando Magallanes"],"correcta":0},
	{"pregunta":"Â¿QuÃ© ciudad es conocida como la ciudad del amor?","respuestas":["Venecia","ParÃ­s","Madrid","Roma"],"correcta":1},
	{"pregunta":"Â¿QuÃ© paÃ­s tiene la mayor poblaciÃ³n mundial?","respuestas":["India","Estados Unidos","China","Brasil"],"correcta":2},
	{"pregunta":"Â¿QuiÃ©n pintÃ³ 'El Guernica'?","respuestas":["DalÃ­","Picasso","VelÃ¡zquez","Goya"],"correcta":1},
	{"pregunta":"Â¿En quÃ© paÃ­s naciÃ³ Ludwig van Beethoven?","respuestas":["Austria","Alemania","Italia","Francia"],"correcta":1},
	{"pregunta":"Â¿CuÃ¡l es el animal sÃ­mbolo de Australia?","respuestas":["Koala","Canguro","EmÃº","Dingo"],"correcta":1},
	{"pregunta":"Â¿QuÃ© paÃ­s es conocido por la pizza y la pasta?","respuestas":["EspaÃ±a","Italia","Francia","MÃ©xico"],"correcta":1},
	{"pregunta":"Â¿QuiÃ©n escribiÃ³ 'La Odisea'?","respuestas":["Homero","Virgilio","SÃ³focles","PlatÃ³n"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la capital de Egipto?","respuestas":["El Cairo","AlejandrÃ­a","Luxor","Giza"],"correcta":0},
	{"pregunta":"Â¿QuÃ© civilizaciÃ³n construyÃ³ Machu Picchu?","respuestas":["Maya","Inca","Azteca","Olmeca"],"correcta":1},
	{"pregunta":"Â¿QuiÃ©n fue el autor de 'Hamlet'?","respuestas":["Shakespeare","Cervantes","Tolstoi","Kafka"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es el paÃ­s mÃ¡s pequeÃ±o del mundo?","respuestas":["MÃ³naco","San Marino","Ciudad del Vaticano","Liechtenstein"],"correcta":2},
	{"pregunta":"Â¿QuÃ© festival hindÃº celebra la victoria de la luz sobre la oscuridad?","respuestas":["Diwali","Holi","Vesak","RamadÃ¡n"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n escribiÃ³ '1984'?","respuestas":["George Orwell","Aldous Huxley","Ray Bradbury","Jules Verne"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la capital de Australia?","respuestas":["SÃ­dney","Melbourne","Canberra","Brisbane"],"correcta":2},
	{"pregunta":"Â¿En quÃ© paÃ­s se encuentra la Torre de Pisa?","respuestas":["Italia","Francia","EspaÃ±a","Alemania"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n pintÃ³ 'La persistencia de la memoria'?","respuestas":["DalÃ­","Picasso","Monet","Van Gogh"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es el idioma oficial de JapÃ³n?","respuestas":["JaponÃ©s","Coreano","Chino","InglÃ©s"],"correcta":0},
	{"pregunta":"Â¿En quÃ© aÃ±o llegÃ³ el hombre a la Luna?","respuestas":["1969","1972","1959","1965"],"correcta":0},
	{"pregunta":"Â¿QuiÃ©n es el autor de 'Don Juan Tenorio'?","respuestas":["JosÃ© Zorrilla","Miguel de Unamuno","Federico GarcÃ­a Lorca","Benito PÃ©rez GaldÃ³s"],"correcta":0},
	{"pregunta":"Â¿QuÃ© paÃ­s tiene como sÃ­mbolo nacional el dragÃ³n?","respuestas":["China","JapÃ³n","Corea","Tailandia"],"correcta":0}
];

var preguntas_ingenieria = [
	{"pregunta":"Â¿QuÃ© hace un ingeniero de software?","respuestas":["Desarrolla programas y aplicaciones","Construye puentes","Opera maquinaria pesada","Vende productos tecnolÃ³gicos"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l de estos lenguajes se utiliza para programar?","respuestas":["EspaÃ±ol","Python","LatÃ­n","FrancÃ©s"],"correcta":1},
	{"pregunta":"Â¿QuÃ© significa 'HTML'?","respuestas":["HyperText Markup Language","HighText Machine Language","Hyper Transfer Markup Language","Hyperlink Markup Language"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la principal funciÃ³n de un ingeniero civil?","respuestas":["DiseÃ±ar y supervisar construcciones","Desarrollar software","Administrar redes informÃ¡ticas","Investigar en laboratorios"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero elÃ©ctrico?","respuestas":["DiseÃ±a ropa","DiseÃ±a sistemas elÃ©ctricos y electrÃ³nicos","Escribe software","Administra bases de datos"],"correcta":1},
	{"pregunta":"Â¿QuÃ© es un algoritmo en programaciÃ³n?","respuestas":["Conjunto de pasos para resolver un problema","Un tipo de computadora","Un virus informÃ¡tico","Un lenguaje humano"],"correcta":0},
	{"pregunta":"Â¿QuÃ© herramienta se utiliza para versionar cÃ³digo?","respuestas":["Word","Excel","Photoshop","Git"],"correcta":3},
	{"pregunta":"Â¿QuÃ© es un circuito elÃ©ctrico?","respuestas":["Camino por el que circula la corriente elÃ©ctrica","Un programa informÃ¡tico","Un puente de carretera","Un componente mecÃ¡nico"],"correcta":0},
	{"pregunta":"Â¿QuÃ© lenguaje se usa principalmente para desarrollo web frontend?","respuestas":["JavaScript","Python","C++","Java"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la funciÃ³n de un ingeniero mecÃ¡nico?","respuestas":["DiseÃ±ar y mantener sistemas mecÃ¡nicos","Programar aplicaciones mÃ³viles","Gestionar bases de datos","Supervisar redes elÃ©ctricas"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es la Inteligencia Artificial?","respuestas":["SimulaciÃ³n de la inteligencia humana en mÃ¡quinas","Un lenguaje de programaciÃ³n","Un sistema operativo","Una red de computadoras"],"correcta":0},
	{"pregunta":"Â¿QuÃ© representa un diagrama de flujo?","respuestas":["El flujo de pasos de un proceso o algoritmo","El plano de un edificio","El diseÃ±o de un circuito elÃ©ctrico","La jerarquÃ­a de una empresa"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero de datos?","respuestas":["DiseÃ±a y mantiene sistemas de gestiÃ³n de datos","Construye puentes","DiseÃ±a circuitos elÃ©ctricos","Administra la logÃ­stica de una empresa"],"correcta":0},
	{"pregunta":"Â¿QuÃ© significa 'API'?","respuestas":["Application Programming Interface","Applied Program Instruction","Automatic Processing Interface","Active Protocol Integration"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un servidor en informÃ¡tica?","respuestas":["Computadora que proporciona servicios a otras","Un tipo de software antivirus","Un lenguaje de programaciÃ³n","Un procesador"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero en telecomunicaciones?","respuestas":["DiseÃ±a y gestiona redes de comunicaciÃ³n","Desarrolla videojuegos","Construye maquinaria","DiseÃ±a moda"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es el 'backend' en desarrollo web?","respuestas":["La parte del servidor y lÃ³gica de la aplicaciÃ³n","El diseÃ±o visual de una pÃ¡gina web","La red de computadoras","El hardware de un servidor"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es el lenguaje mÃ¡s usado en inteligencia artificial y machine learning?","respuestas":["Python","JavaScript","PHP","HTML"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es la nube (cloud computing)?","respuestas":["Almacenamiento y servicios por internet","Un disco duro fÃ­sico","Un tipo de computadora portÃ¡til","Un lenguaje de programaciÃ³n"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es GitHub?","respuestas":["Plataforma para alojar y colaborar en proyectos de software","Un sistema operativo","Un lenguaje de programaciÃ³n","Un tipo de base de datos"],"correcta":0},
	{"pregunta":"Â¿QuÃ© se usa para modelar piezas en 3D?","respuestas":["AutoCAD","Excel","Word","Photoshop"],"correcta":0},
	{"pregunta":"Â¿QuÃ© tipo de ingeniero diseÃ±a aviones?","respuestas":["Ingeniero aeronÃ¡utico","Ingeniero civil","Ingeniero quÃ­mico","Ingeniero industrial"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero quÃ­mico?","respuestas":["DiseÃ±a procesos y productos quÃ­micos","Construye edificios","Opera maquinaria pesada","Desarrolla videojuegos"],"correcta":0},
	{"pregunta":"Â¿QuÃ© instrumento mide la presiÃ³n atmosfÃ©rica?","respuestas":["BarÃ³metro","TermÃ³metro","AmperÃ­metro","MultÃ­metro"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es una impresora 3D?","respuestas":["Una mÃ¡quina que crea objetos fÃ­sicos a partir de modelos digitales","Una computadora portÃ¡til","Un servidor web","Un programa de ediciÃ³n"],"correcta":0},
	{"pregunta":"Â¿QuÃ© tipo de ingeniero trabaja con energÃ­as renovables?","respuestas":["Ingeniero ambiental","Ingeniero civil","Ingeniero de datos","Ingeniero mecÃ¡nico"],"correcta":0},
	{"pregunta":"Â¿QuÃ© software se usa para crear planos arquitectÃ³nicos?","respuestas":["AutoCAD","Excel","Matlab","Word"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es una variable en programaciÃ³n?","respuestas":["Un espacio para almacenar datos","Un componente mecÃ¡nico","Un tipo de servidor","Un circuito elÃ©ctrico"],"correcta":0},
	{"pregunta":"Â¿CuÃ¡l es la funciÃ³n de un ingeniero industrial?","respuestas":["Optimizar procesos y sistemas productivos","Desarrollar software","DiseÃ±ar puentes","Crear videojuegos"],"correcta":0},
	{"pregunta":"Â¿QuÃ© lenguaje se usa para aplicaciones mÃ³viles Android?","respuestas":["Java","Python","PHP","HTML"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es una base de datos?","respuestas":["Sistema para almacenar y gestionar informaciÃ³n","Un programa de diseÃ±o","Un tipo de hardware","Un lenguaje de programaciÃ³n"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un sensor?","respuestas":["Dispositivo que detecta cambios en su entorno","Un lenguaje de programaciÃ³n","Una computadora portÃ¡til","Un tipo de red"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es la robÃ³tica?","respuestas":["Estudio y diseÃ±o de robots","DiseÃ±o de moda","ProducciÃ³n de alimentos","GestiÃ³n de empresas"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un microprocesador?","respuestas":["El cerebro de la computadora","Un tipo de impresora","Una aplicaciÃ³n mÃ³vil","Un software antivirus"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es una resistencia elÃ©ctrica?","respuestas":["Componente que limita el flujo de corriente","Un tipo de software","Una impresora","Un lenguaje de programaciÃ³n"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero en sistemas?","respuestas":["DiseÃ±a y gestiona sistemas informÃ¡ticos","Construye puentes","Opera maquinaria pesada","DiseÃ±a circuitos elÃ©ctricos"],"correcta":0},
	{"pregunta":"Â¿QuÃ© lenguaje se usa para el desarrollo de iOS?","respuestas":["Swift","Java","C++","PHP"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un plano elÃ©ctrico?","respuestas":["Diagrama de un sistema elÃ©ctrico","Plano de una casa","Mapa de una ciudad","DiseÃ±o de una pÃ¡gina web"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un compilador?","respuestas":["Programa que traduce cÃ³digo fuente a ejecutable","Un software de diseÃ±o","Un servidor web","Un componente mecÃ¡nico"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es el Internet de las cosas (IoT)?","respuestas":["Red de dispositivos conectados a Internet","Un tipo de base de datos","Un lenguaje de programaciÃ³n","Un software de diseÃ±o"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero de hardware?","respuestas":["DiseÃ±a componentes fÃ­sicos de computadoras","Desarrolla software","Gestiona redes","Opera maquinaria pesada"],"correcta":0},
	{"pregunta":"Â¿QuÃ© instrumento mide la temperatura?","respuestas":["TermÃ³metro","BarÃ³metro","MultÃ­metro","AmperÃ­metro"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un sistema operativo?","respuestas":["Software que administra recursos del computador","Un componente mecÃ¡nico","Un lenguaje de programaciÃ³n","Un circuito elÃ©ctrico"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero de redes?","respuestas":["DiseÃ±a, configura y mantiene redes informÃ¡ticas","Construye puentes","Desarrolla software","Opera maquinaria pesada"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es un PLC?","respuestas":["Controlador lÃ³gico programable","Un tipo de procesador","Un software de diseÃ±o","Un lenguaje de programaciÃ³n"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es una interfaz grÃ¡fica de usuario (GUI)?","respuestas":["Medio visual para interactuar con software","Un componente mecÃ¡nico","Un tipo de servidor","Un circuito elÃ©ctrico"],"correcta":0},
	{"pregunta":"Â¿QuÃ© es la ingenierÃ­a genÃ©tica?","respuestas":["ModificaciÃ³n de genes de organismos vivos","DiseÃ±o de circuitos elÃ©ctricos","ConstrucciÃ³n de puentes","Desarrollo de software"],"correcta":0},
	{"pregunta":"Â¿QuÃ© lenguaje se usa para pÃ¡ginas web?","respuestas":["HTML","Python","C++","Java"],"correcta":0},
	{"pregunta":"Â¿QuÃ© hace un ingeniero ambiental?","respuestas":["Trabaja en la protecciÃ³n del medio ambiente","Desarrolla software","Construye puentes","Opera maquinaria pesada"],"correcta":0}
];

var preguntas_restantes = []
var pregunta_actual = {}
var puntaje = 0
var categoria_seleccionada = ""
var puntaje_maximo = 0
var total_preguntas = 20

func _ready():
	# Estilo profesional en la UI
	$Label.text = "ðŸ§  Selecciona la categorÃ­a para comenzar"
	$Label.add_theme_color_override("font_color", Color(0.2, 0.2, 0.7))
	$Label.add_theme_font_size_override("font_size", 28)
	$Mensaje.text = ""
	$Mensaje.add_theme_color_override("font_color", Color(0.1, 0.5, 0.1))
	$Mensaje.add_theme_font_size_override("font_size", 22)

	$Boton0.text = "Cultura General"
	$Boton1.text = "IngenierÃ­a"
	$Boton2.hide()
	$Boton3.hide()
	$Boton4.text = "Salir"
	$Boton5.text = "Intentar de nuevo"
	$Boton5.hide()

	$Boton0.connect("pressed", Callable(self, "_on_Boton0_pressed"))
	$Boton1.connect("pressed", Callable(self, "_on_Boton1_pressed"))
	$Boton2.connect("pressed", Callable(self, "_on_Boton2_pressed"))
	$Boton3.connect("pressed", Callable(self, "_on_Boton3_pressed"))
	$Boton4.connect("pressed", Callable(self, "_on_Boton4_pressed"))
	$Boton5.connect("pressed", Callable(self, "_on_Boton5_pressed"))

	# Cargar puntaje mÃ¡ximo guardado
	var load = FileAccess.open("user://trivia_solitario.save", FileAccess.READ)
	if load:
		if load.get_length() > 0:
			puntaje_maximo = load.get_32()
		load.close()

func reproducir_audio_correct():
	$CorrectAudio.play()
func reproducir_audio_error():
	$ErrorAudio.play()
func _on_Boton0_pressed():
	if categoria_seleccionada == "":
		iniciar_juego("cultura")
	else:
		verificar_respuesta(0)

func _on_Boton1_pressed():
	if categoria_seleccionada == "":
		iniciar_juego("ingenieria")
	else:
		verificar_respuesta(1)

func _on_Boton2_pressed():
	verificar_respuesta(2)

func _on_Boton3_pressed():
	verificar_respuesta(3)

func _on_Boton4_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/trivia.tscn")

func _on_Boton5_pressed():
	get_tree().reload_current_scene()

func iniciar_juego(categoria):
	categoria_seleccionada = categoria
	var fuente = []
	if categoria == "cultura":
		fuente = preguntas_cultura.duplicate()
	elif categoria == "ingenieria":
		fuente = preguntas_ingenieria.duplicate()
	fuente.shuffle()
	preguntas_restantes = fuente.slice(0, total_preguntas)
	puntaje = 0
	$Boton2.show()
	$Boton3.show()
	$Boton0.hide()
	$Boton1.hide()
	$Boton5.hide()
	mostrar_pregunta_aleatoria()

func mostrar_pregunta_aleatoria():
	if preguntas_restantes.size() == 0:
		mostrar_resultado()
		return
	pregunta_actual = preguntas_restantes.pop_front()
	$Label.text = "Pregunta %d/%d:\n%s" % [total_preguntas - preguntas_restantes.size(), total_preguntas, pregunta_actual["pregunta"]]
	for i in range(4):
		var boton = get_node("Boton%d" % i)
		if i < pregunta_actual["respuestas"].size():
			boton.text = pregunta_actual["respuestas"][i]
			boton.disabled = false
			boton.show()
		else:
			boton.hide()
	$Mensaje.text = ""

func verificar_respuesta(indice):
	for i in range(4):
		get_node("Boton%d" % i).disabled = true

	# Guardar colores originales usando modulate
	var colores_originales = []
	for i in range(4):
		var boton = get_node("Boton%d" % i)
		colores_originales.append(boton.modulate)

	# Verificar respuesta
	if indice == pregunta_actual["correcta"]:
		puntaje += 1
		$Mensaje.text = "âœ… Â¡Correcto!"
		reproducir_audio_correct()
		get_node("Boton%d" % indice).modulate = Color(0, 1, 0)  # Verde
	else:
		$Mensaje.text = "âŒ Incorrecto"
		reproducir_audio_error()
		get_node("Boton%d" % indice).modulate = Color(1, 0, 0)  # Rojo
		get_node("Boton%d" % pregunta_actual["correcta"]).modulate = Color(0, 1, 0)

	await get_tree().create_timer(1.2).timeout

	# Restaurar colores originales
	for i in range(4):
		var boton = get_node("Boton%d" % i)
		boton.modulate = colores_originales[i]
		boton.disabled = false

	mostrar_pregunta_aleatoria()





func mostrar_resultado():
	if puntaje > puntaje_maximo:
		puntaje_maximo = puntaje
		# Guardar puntaje mÃ¡ximo
		var save = FileAccess.open("user://trivia_solitario.save", FileAccess.WRITE)
		if save:
			save.store_32(puntaje_maximo)
			save.close()
	var porcentaje = (float(puntaje) / float(total_preguntas)) * 100
	var mensaje_evaluacion = ""
	if porcentaje >= 80:
		mensaje_evaluacion = "ðŸŒŸ Â¡Excelente trabajo!"
	elif porcentaje >= 60:
		mensaje_evaluacion = "ðŸ‘ Â¡Bien hecho!"
	elif porcentaje >= 40:
		mensaje_evaluacion = "ðŸ”„ Puedes mejorar"
	else:
		mensaje_evaluacion = "ðŸ“š Necesitas estudiar mÃ¡s"
	$Label.text = "ðŸŽ‰ Â¡Trivia terminada!\n%s\nRespuestas correctas: %d de %d\nPorcentaje: %d%%\nðŸ† Mejor puntaje: %d" % [mensaje_evaluacion, puntaje, total_preguntas, int(porcentaje), puntaje_maximo]
	$Boton0.hide()
	$Boton1.hide()
	$Boton2.hide()
	$Boton3.hide()
	$Boton4.show()
	$Boton5.show()
	$Mensaje.text = ""

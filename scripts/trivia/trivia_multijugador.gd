extends Control

# MenÃº multijugador: elegir ser anfitriÃ³n o unirse a sala
func _ready():
	$Label.text = "Multijugador: Elige una opciÃ³n"
	$Boton0.text = "Ser anfitriÃ³n"
	$Boton1.text = "Unirse a sala"
	$Boton2.hide()
	$Boton3.hide()
	$Mensaje.text = ""
	$Boton4.text = "Volver"

	$Boton0.connect("pressed", Callable(self, "_on_Boton0_pressed"))
	$Boton1.connect("pressed", Callable(self, "_on_Boton1_pressed"))
	$Boton4.connect("pressed", Callable(self, "_on_Boton4_pressed"))

func reproducir_sonido_click():
	$AudioClick.play()

func _on_Boton0_pressed():
	reproducir_sonido_click()
	# Ir a la escena de anfitriÃ³n
	var path = "res://scenes/ui/trivia_host.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		$Mensaje.text = "Escena de host no encontrada: %s" % path

func _on_Boton1_pressed():
	reproducir_sonido_click()
	# Ir a la escena de cliente
	var path = "res://scenes/ui/trivia_client.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		$Mensaje.text = "Escena de cliente no encontrada: %s" % path

func _on_Boton4_pressed():
	reproducir_sonido_click()
	get_tree().change_scene_to_file("res://scenes/ui/trivia.tscn")
	

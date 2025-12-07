


# MenÃº principal de la trivia
 # Este script debe extender Control para usar la notaciÃ³n $ y get_tree()
extends Control
func _ready():
	$Label.text = "Selecciona un modo de juego"
	$Boton0.text = "Solitario"
	$Boton1.text = "Multijugador"
	$Boton4.text = "Salir"

	$Boton0.connect("pressed", Callable(self, "_on_Boton0_pressed"))
	$Boton1.connect("pressed", Callable(self, "_on_Boton1_pressed"))
	$Boton4.connect("pressed", Callable(self, "_on_Boton4_pressed"))

func reproducir_sonido_click():
	$AudioClick.play()

func _on_Boton0_pressed():
	reproducir_sonido_click()
	# Ir a la escena de trivia solitaria
	get_tree().change_scene_to_file("res://scenes/ui/trivia_solitario.tscn")

func _on_Boton1_pressed():
	reproducir_sonido_click()
	# Ir a la escena de menÃº multijugador
	get_tree().change_scene_to_file("res://scenes/ui/trivia_multijugador.tscn")

func _on_Boton4_pressed():
	reproducir_sonido_click()
	get_tree().change_scene_to_file("res://scenes/levels/mundo.tscn")

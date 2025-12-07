extends Node2D

@onready var title_label: Label = $Title_Label
@onready var start_button: Button = $StartButton
@onready var instructions_label: Label = $InstructionsLabel

func _ready():
	
	# Configurar interfaz del menÃº
	title_label.text = "SPACE INVADERS"
	title_label.position = Vector2(400, 200)
	
	start_button.text = "INICIAR"
	start_button.position = Vector2(325, 500)
	
	instructions_label.text = "Usa A/D o las Flechas para moverte\nEspacio para disparar\nR para reiniciar\nESC para salir"
	instructions_label.position = Vector2(400, 400)

func _on_start_button_pressed():
	print("Starting game from menu...")
	get_tree().change_scene_to_file("res://spaceship/scenes/Main.tscn")

func _input(event):
	if event.is_action_pressed("shoot") or event.is_action_pressed("ui_accept"):
		_on_start_button_pressed()
	
	# Salir del spaceship y volver al menÃº principal del juego con ESC
	if event.is_action_pressed("ui_cancel"):
		print("ESC pressed - returning to main game menu...")
		get_tree().change_scene_to_file("res://scenes/levels/mundo.tscn")

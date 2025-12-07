extends Node2D

# Nodos
@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var game_over_label: Label = $GameOverLabel

# Nodos de high score (se crearÃ¡n dinÃ¡micamente)
var high_scores_panel: ColorRect
var high_scores_label: Label
var name_input_panel: ColorRect
var name_input_label: Label
var name_line_edit: LineEdit
var name_instruction_label: Label

var current_score: int = 0
var is_high_score: bool = false
var waiting_for_name: bool = false

func _ready():
	# Configurar labels
	score_label.text = "Puntaje: 0"
	lives_label.text = "VIDAS: 3"
	game_over_label.text = ""
	game_over_label.visible = false
	
	# Posicionar elementos
	score_label.position = Vector2(20, 20)
	lives_label.position = Vector2(20, 50)
	game_over_label.position = Vector2(400, 350)
	
	# Crear elementos de high scores
	create_high_score_ui()

func create_high_score_ui():
	"""Crear elementos de UI para high scores y entrada de nombre"""
	
	# Panel de high scores
	high_scores_panel = ColorRect.new()
	high_scores_panel.name = "HighScoresPanel"
	high_scores_panel.color = Color(0, 0, 0, 0.85)
	high_scores_panel.size = Vector2(400, 350)
	high_scores_panel.position = Vector2(223, 125)  # Centrado en 846px
	high_scores_panel.visible = false
	add_child(high_scores_panel)
	
	# Label de high scores
	high_scores_label = Label.new()
	high_scores_label.name = "HighScoresLabel"
	high_scores_label.position = Vector2(20, 20)
	high_scores_label.size = Vector2(360, 310)
	high_scores_label.add_theme_font_size_override("font_size", 16)
	high_scores_label.add_theme_color_override("font_color", Color.WHITE)
	high_scores_panel.add_child(high_scores_label)
	
	# Panel de entrada de nombre
	name_input_panel = ColorRect.new()
	name_input_panel.name = "NameInputPanel"
	name_input_panel.color = Color(0.1, 0.3, 0.5, 0.95)
	name_input_panel.size = Vector2(400, 200)
	name_input_panel.position = Vector2(223, 250)
	name_input_panel.visible = false
	add_child(name_input_panel)
	
	# Label de congratulations
	name_input_label = Label.new()
	name_input_label.name = "NameInputLabel"
	name_input_label.text = "ðŸ† Nuevo Puntaje Maximo! ðŸ†"
	name_input_label.position = Vector2(20, 20)
	name_input_label.size = Vector2(360, 30)
	name_input_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_input_label.add_theme_font_size_override("font_size", 20)
	name_input_label.add_theme_color_override("font_color", Color.YELLOW)
	name_input_panel.add_child(name_input_label)
	
	# Instrucciones
	name_instruction_label = Label.new()
	name_instruction_label.name = "NameInstructionLabel"
	name_instruction_label.text = "Ingresa tu Nombre (max 3 letras):"
	name_instruction_label.position = Vector2(20, 70)
	name_instruction_label.size = Vector2(360, 30)
	name_instruction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_instruction_label.add_theme_font_size_override("font_size", 14)
	name_instruction_label.add_theme_color_override("font_color", Color.WHITE)
	name_input_panel.add_child(name_instruction_label)
	
	# LineEdit para nombre
	name_line_edit = LineEdit.new()
	name_line_edit.name = "NameLineEdit"
	name_line_edit.position = Vector2(100, 110)
	name_line_edit.size = Vector2(200, 40)
	name_line_edit.max_length = 3
	name_line_edit.placeholder_text = "ABC"
	name_line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_line_edit.add_theme_font_size_override("font_size", 24)
	name_line_edit.text_submitted.connect(_on_name_submitted)
	name_input_panel.add_child(name_line_edit)
	
	print("âœ… High score UI created")

func _on_score_changed(score: int):
	current_score = score
	score_label.text = "Puntaje: " + str(score)

func _on_lives_changed(lives: int):
	lives_label.text = "Vidas: " + str(lives)

func _on_game_over():
	print("=== GAME OVER ===")
	print("Puntaje Final: ", current_score)
	
	# Verificar si es un high score
	is_high_score = HighScores.is_high_score(current_score)
	
	if is_high_score:
		var rank = HighScores.get_rank_position(current_score)
		print("ðŸŽ‰ Felicidades! Position: #", rank + 1)
		show_name_input()
	else:
		print("Score doesn't qualify for high scores")
		show_game_over_with_scores()

func show_name_input():
	"""Mostrar panel de entrada de nombre"""
	waiting_for_name = true
	name_input_panel.visible = true
	game_over_label.visible = false
	
	# Enfocar el LineEdit
	name_line_edit.text = ""
	name_line_edit.grab_focus()
	
	print("ðŸ“ Waiting for player name input...")

func _on_name_submitted(player_name: String):
	"""Manejar el envÃ­o del nombre del jugador"""
	if player_name.strip_edges() == "":
		player_name = "AAA"  # Nombre por defecto
	
	player_name = player_name.to_upper().strip_edges()
	
	# Agregar el high score
	var position = HighScores.add_high_score(player_name, current_score)
	
	print("âœ… High score saved: ", player_name, " - ", current_score)
	
	# Ocultar panel de entrada
	name_input_panel.visible = false
	waiting_for_name = false
	
	# Mostrar tabla de high scores
	show_game_over_with_scores()

func show_game_over_with_scores():
	"""Mostrar Game Over con tabla de high scores"""
	game_over_label.text = "GAME OVER"
	game_over_label.visible = true
	game_over_label.position = Vector2(350, 80)
	
	# Construir texto de high scores
	var scores_text = "â•â•â• TOP 5 Mejores Puntajes â•â•â•\n\n"
	var scores = HighScores.get_high_scores()
	
	for i in range(scores.size()):
		var entry = scores[i]
		var rank_icon = ""
		match i:
			0: rank_icon = "ðŸ¥‡"
			1: rank_icon = "ðŸ¥ˆ"
			2: rank_icon = "ðŸ¥‰"
			_: rank_icon = "  "
		
		scores_text += rank_icon + " #" + str(i + 1) + "  " + entry["name"] + " .......... " + str(entry["score"]) + "\n"
	
	scores_text += "\n\nPresiona R para reiniciar \nPresiona ESC para salir"
	
	high_scores_label.text = scores_text
	high_scores_panel.visible = true
	
	print("ðŸ“Š High scores displayed")

func hide_game_over():
	"""Ocultar mensaje de Game Over (para reinicio)"""
	game_over_label.visible = false
	game_over_label.text = ""
	high_scores_panel.visible = false
	name_input_panel.visible = false
	waiting_for_name = false
	current_score = 0
	is_high_score = false
	print("Game Over message hidden")

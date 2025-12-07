extends Node

# Sistema de High Scores - Top 5
# Guarda y gestiona los mejores puntajes del juego

const SAVE_PATH = "user://highscores.save"
const MAX_SCORES = 5

# Array de diccionarios: [{name: "Player", score: 1000}, ...]
var high_scores: Array = []

func _ready():
	print("=== HIGH SCORES SYSTEM INITIALIZED ===")
	load_scores()

func load_scores():
	"""Cargar scores desde el archivo"""
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				high_scores = json.get_data()
				print("âœ… High scores loaded: ", high_scores.size(), " entries")
			else:
				print("âš ï¸ Error parsing high scores, creating new list")
				initialize_default_scores()
		else:
			print("âš ï¸ Could not open save file, creating new list")
			initialize_default_scores()
	else:
		print("ðŸ“ No save file found, creating new high scores list")
		initialize_default_scores()

func save_scores():
	"""Guardar scores al archivo"""
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(high_scores)
		file.store_string(json_string)
		file.close()
		print("ðŸ’¾ High scores saved successfully")
		return true
	else:
		print("âŒ Error saving high scores")
		return false

func initialize_default_scores():
	"""Inicializar con scores por defecto"""
	high_scores = [
		{"name": "ACE", "score": 500},
		{"name": "PRO", "score": 400},
		{"name": "VET", "score": 300},
		{"name": "ADV", "score": 200},
		{"name": "NEW", "score": 100}
	]
	save_scores()
	print("âœ¨ Default high scores initialized")

func is_high_score(score: int) -> bool:
	"""Verificar si un puntaje califica para el ranking"""
	if high_scores.size() < MAX_SCORES:
		return true
	
	# Verificar si es mayor que el puntaje mÃ¡s bajo
	return score > high_scores[MAX_SCORES - 1]["score"]

func get_rank_position(score: int) -> int:
	"""Obtener la posiciÃ³n que ocuparÃ­a el puntaje en el ranking (-1 si no califica)"""
	if not is_high_score(score):
		return -1
	
	for i in range(high_scores.size()):
		if score > high_scores[i]["score"]:
			return i
	
	# Si llegamos aquÃ­ y hay espacio, va al final
	if high_scores.size() < MAX_SCORES:
		return high_scores.size()
	
	return -1

func add_high_score(player_name: String, score: int) -> int:
	"""Agregar un nuevo high score y retornar su posiciÃ³n"""
	var position = get_rank_position(score)
	
	if position == -1:
		print("âš ï¸ Score doesn't qualify for ranking")
		return -1
	
	var new_entry = {"name": player_name, "score": score}
	
	# Insertar en la posiciÃ³n correcta
	high_scores.insert(position, new_entry)
	
	# Mantener solo los top 5
	if high_scores.size() > MAX_SCORES:
		high_scores.resize(MAX_SCORES)
	
	save_scores()
	
	print("ðŸ† New high score added!")
	print("   Position: #", position + 1)
	print("   Name: ", player_name)
	print("   Score: ", score)
	
	return position

func get_high_scores() -> Array:
	"""Obtener el array de high scores"""
	return high_scores

func get_formatted_scores() -> String:
	"""Obtener scores formateados como texto"""
	var text = "=== TOP 5 HIGH SCORES ===\n\n"
	
	for i in range(high_scores.size()):
		var entry = high_scores[i]
		text += str(i + 1) + ". " + entry["name"] + " - " + str(entry["score"]) + "\n"
	
	return text

func print_high_scores():
	"""Imprimir high scores en consola"""
	print("\n" + get_formatted_scores())

func clear_scores():
	"""Limpiar todos los scores (Ãºtil para debug/testing)"""
	initialize_default_scores()
	print("ðŸ—‘ï¸ High scores cleared and reset to defaults")

# ============================================================================
# TRIVIA MULTIPLAYER STRATEGY
# ============================================================================
# ImplementaciÃ³n de la estrategia para modo multijugador
#
# DESIGN PATTERNS: Strategy Pattern (ImplementaciÃ³n concreta)
# SOLID: [SRP] Responsabilidad Ãºnica: Manejar lÃ³gica de trivia multijugador
# ============================================================================

class_name TriviaMultiplayerStrategy
extends TriviaStrategy

var _game_manager: TriviaGameManager
var _question_bank
var _player_scores: Dictionary = {}
var _network_manager

func initialize(question_bank) -> void:
	_question_bank = question_bank
	_game_manager = TriviaGameManager.new()
	
	# Conectar seÃ±ales
	_game_manager.game_started.connect(func(cat): game_started.emit(cat))
	_game_manager.question_changed.connect(func(q, n, t): question_changed.emit(q, n, t))
	_game_manager.answer_submitted.connect(func(c, a): 
		answer_submitted.emit(c, a)
		_sync_scores()
	)

func start_game(category: String, question_count: int) -> void:
	var questions = _question_bank.get_random_questions(category, question_count)
	_game_manager.start_game(questions)
	# TODO: Sincronizar preguntas entre jugadores via red

func handle_answer(answer_index: int) -> void:
	_game_manager.submit_answer(answer_index)
	# TODO: Enviar respuesta al servidor

func show_next_question() -> void:
	_game_manager.show_next_question()

func end_game() -> Dictionary:
	var results = {
		"player_scores": _player_scores,
		"winner": _get_winner(),
		"local_score": _game_manager.get_score(),
		"total_questions": _game_manager.get_total_questions()
	}
	game_ended.emit(results)
	return results

func _get_winner() -> String:
	if _player_scores.is_empty():
		return "Local Player"
	
	var max_score = 0
	var winner = ""
	for player_id in _player_scores:
		if _player_scores[player_id] > max_score:
			max_score = _player_scores[player_id]
			winner = player_id
	
	return winner

#func _sync_scores() -> void:
	## TODO: Sincronizar puntajes via red
	#if multiplayer:
		#_player_scores[str(multiplayer.get_unique_id())] = _game_manager.get_score()
	#else:
		#_player_scores["local_player"] = _game_manager.get_score()

func get_current_score() -> int:
	return _game_manager.get_score()

# ============================================================================
# TRIVIA STRATEGY (Interface)
# ============================================================================
# Define la interfaz para diferentes estrategias de trivia
#
# DESIGN PATTERNS APPLIED:
# ------------------------
# [Strategy Pattern] PatrÃ³n de Comportamiento
#       Encapsula algoritmos intercambiables (solitario, multijugador, etc.)
#       Permite cambiar el comportamiento en tiempo de ejecuciÃ³n
#
# SOLID PRINCIPLES:
# -----------------
# [OCP] Open/Closed - Nuevas estrategias sin modificar cÃ³digo existente
# [SRP] Single Responsibility - Cada estrategia maneja un modo especÃ­fico
# [DIP] Dependency Inversion - El cliente depende de la abstracciÃ³n, no de implementaciones
# ============================================================================

class_name TriviaStrategy
extends RefCounted

## SeÃ±ales para comunicaciÃ³n con la UI
signal game_started(category: String)
signal question_changed(question_data: Dictionary, question_number: int, total: int)
signal answer_submitted(is_correct: bool, correct_answer: int)
signal game_ended(results: Dictionary)

## Inicializa el modo de juego
## @param _question_bank: Banco de preguntas a utilizar
func initialize(_question_bank) -> void:
    pass

## Inicia el juego con la configuraciÃ³n especÃ­fica
## @param _category: CategorÃ­a de preguntas
## @param _question_count: NÃºmero de preguntas
func start_game(_category: String, _question_count: int) -> void:
    pass

## Maneja la respuesta del jugador
## @param _answer_index: Ã­ndice de la respuesta seleccionada
func handle_answer(_answer_index: int) -> void:
    pass

## Finaliza el juego y retorna resultados
## @returns: Dictionary con resultados finales
func end_game() -> Dictionary:
    return {}

## Retorna el puntaje actual
func get_current_score() -> int:
    return 0

## Muestra la siguiente pregunta
func show_next_question() -> void:
    pass
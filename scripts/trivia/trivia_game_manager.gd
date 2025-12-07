# ============================================================================
# TRIVIA GAME MANAGER
# ============================================================================
# Gestor del estado y flujo del juego de trivia
#
# SOLID PRINCIPLES APPLIED:
# -------------------------
# [SRP] Single Responsibility Principle (Principio de Responsabilidad Ãšnica)
#       Esta clase tiene UNA sola responsabilidad: gestionar el estado del juego
#       de trivia (puntaje, preguntas actuales, progreso). No maneja UI, datos
#       de preguntas, ni lÃ³gica de red.
#
# [OCP] Open/Closed Principle (Principio Abierto/Cerrado)
#       Abierto para extensiÃ³n mediante seÃ±ales, cerrado para modificaciÃ³n.
#       Nuevas funcionalidades se pueden agregar escuchando las seÃ±ales sin
#       modificar esta clase.
#
# Benefits:
# - FÃ¡cil de testear: lÃ³gica aislada sin dependencias de UI
# - Reutilizable: puede usarse en modo solitario o multijugador
# - Mantenible: cambios en una responsabilidad no afectan otras
# ============================================================================

class_name TriviaGameManager
extends Node

# SeÃ±ales para comunicaciÃ³n desacoplada (DIP - Dependency Inversion)
signal game_started(category: String)
signal question_changed(question_data: Dictionary, question_number: int, total: int)
signal answer_submitted(is_correct: bool, correct_answer: int)
signal game_ended(final_score: int, total_questions: int)

# Estado interno del juego (encapsulado)
var _questions: Array = []
var _current_question_index: int = 0
var _score: int = 0
var _total_questions: int = 0

## Inicia una nueva partida con el conjunto de preguntas proporcionado
## @param questions: Array de diccionarios con estructura {pregunta, respuestas, correcta}
func start_game(questions: Array) -> void:
    _questions = questions.duplicate()
    _current_question_index = 0
    _score = 0
    _total_questions = _questions.size()
    game_started.emit("")
    show_next_question()

## Muestra la siguiente pregunta o termina el juego si no hay mÃ¡s
func show_next_question() -> void:
    if _current_question_index >= _questions.size():
        end_game()
        return
    
    var question = _questions[_current_question_index]
    question_changed.emit(question, _current_question_index + 1, _total_questions)

## Procesa la respuesta del jugador y actualiza el puntaje
## @param answer_index: Ã­ndice de la respuesta seleccionada (0-3)
func submit_answer(answer_index: int) -> void:
    var question = _questions[_current_question_index]
    var is_correct = (answer_index == question["correcta"])
    
    if is_correct:
        _score += 1
    
    answer_submitted.emit(is_correct, question["correcta"])
    _current_question_index += 1

## Finaliza el juego y emite los resultados finales
func end_game() -> void:
    game_ended.emit(_score, _total_questions)

## Retorna el puntaje actual del jugador
func get_score() -> int:
    return _score

## Retorna el nÃºmero total de preguntas en la partida
func get_total_questions() -> int:
    return _total_questions
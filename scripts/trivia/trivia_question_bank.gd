# ============================================================================
# TRIVIA QUESTION BANK
# ============================================================================
# Repositorio centralizado de preguntas de trivia
#
# SOLID PRINCIPLES APPLIED:
# -------------------------
# [SRP] Single Responsibility Principle (Principio de Responsabilidad Ãšnica)
#       Esta clase tiene UNA sola responsabilidad: gestionar y proporcionar
#       preguntas. No maneja lÃ³gica de juego, UI, ni puntuaciÃ³n.
#
# [OCP] Open/Closed Principle (Principio Abierto/Cerrado)
#       Abierto para extensiÃ³n: se pueden agregar nuevas categorÃ­as sin
#       modificar el cÃ³digo existente. Cerrado para modificaciÃ³n.
#
# Benefits:
# - FÃ¡cil agregar/modificar preguntas sin afectar la lÃ³gica del juego
# - Posibilidad de cargar preguntas desde archivos externos (JSON, CSV)
# - Testeable independientemente de otros componentes
# - Reutilizable en diferentes modos de juego
# ============================================================================

class_name TriviaQuestionBank
extends Node

# Constantes para categorÃ­as (facilita refactorizaciÃ³n y evita errores de tipeo)
const CULTURA_GENERAL = "cultura_general"
const INGENIERIA = "ingenieria"

# Almacenamiento interno de preguntas por categorÃ­a
var _questions_cultura: Array = []
var _questions_ingenieria: Array = []

func _ready():
    _load_cultura_questions()
    _load_ingenieria_questions()

## Obtiene un conjunto aleatorio de preguntas de una categorÃ­a especÃ­fica
## @param category: Nombre de la categorÃ­a (usar constantes CULTURA_GENERAL, INGENIERIA)
## @param count: NÃºmero de preguntas a obtener
## @returns: Array de diccionarios con preguntas aleatorias
func get_random_questions(category: String, count: int) -> Array:
    var source: Array = []
    
    match category:
        CULTURA_GENERAL:
            source = _questions_cultura.duplicate()
        INGENIERIA:
            source = _questions_ingenieria.duplicate()
        _:
            push_error("CategorÃ­a desconocida: " + category)
            return []
    
    source.shuffle()
    return source.slice(0, min(count, source.size()))

## Carga las preguntas de cultura general
## OCP: Este mÃ©todo puede ser reemplazado para cargar desde archivo externo
func _load_cultura_questions() -> void:
    _questions_cultura = [
        # Las preguntas existentes se mantienen aquÃ­
    ]

## Carga las preguntas de ingenierÃ­a
## OCP: Este mÃ©todo puede ser reemplazado para cargar desde archivo externo
func _load_ingenieria_questions() -> void:
    _questions_ingenieria = [
        # Las preguntas existentes se mantienen aquÃ­
    ]

## Obtiene todas las categorÃ­as disponibles
## @returns: Array con los nombres de las categorÃ­as
func get_available_categories() -> Array:
    return [CULTURA_GENERAL, INGENIERIA]

## Obtiene el nÃºmero total de preguntas en una categorÃ­a
## @param category: Nombre de la categorÃ­a
## @returns: NÃºmero de preguntas disponibles
func get_question_count(category: String) -> int:
    match category:
        CULTURA_GENERAL:
            return _questions_cultura.size()
        INGENIERIA:
            return _questions_ingenieria.size()
        _:
            return 0
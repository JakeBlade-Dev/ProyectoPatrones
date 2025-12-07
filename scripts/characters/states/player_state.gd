# ============================================================================
# PLAYER STATE (Base)
# ============================================================================
# Interfaz base para el patrón State aplicado al jugador
#
# DESIGN PATTERNS APPLIED:
# ------------------------
# [State Pattern] Patrón de Comportamiento
#       Permite que un objeto altere su comportamiento cuando su estado
#       interno cambia. El objeto parecerá cambiar su clase.
#
# SOLID PRINCIPLES:
# -----------------
# [SRP] Single Responsibility - Cada estado maneja su comportamiento específico
# [OCP] Open/Closed - Nuevos estados sin modificar estados existentes
#
# Benefits:
# - Elimina condicionales complejos if/switch
# - Cada estado es una clase independiente y testeable
# - Transiciones de estado claras y mantenibles
# ============================================================================

class_name PlayerState
extends RefCounted

var _player: CharacterBody2D

func _init(player: CharacterBody2D):
    _player = player

## Llamado cuando se entra en este estado
func enter() -> void:
    pass

## Llamado cada frame mientras el estado está activo
func update(delta: float) -> void:
    pass

## Llamado en physics_process
func physics_update(delta: float) -> void:
    pass

## Llamado cuando se sale de este estado
func exit() -> void:
    pass

## Maneja input del jugador
func handle_input(event: InputEvent) -> void:
    pass

## Retorna el siguiente estado (o null si no hay cambio)
func get_next_state() -> PlayerState:
    return null

## Nombre del estado para debugging
func get_state_name() -> String:
    return "PlayerState"
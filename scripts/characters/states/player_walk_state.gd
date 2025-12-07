# ============================================================================
# PLAYER WALK STATE
# ============================================================================
# Estado de movimiento del jugador
#
# DESIGN PATTERNS: State Pattern (Implementación concreta)
# ============================================================================

class_name PlayerWalkState
extends PlayerState

const SPEED = 150.0

func enter() -> void:
    print("?? Estado: WALK")

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    _player.velocity = input_dir * SPEED
    _player.move_and_slide()

func get_next_state() -> PlayerState:
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if input_dir.length() < 0.1:
        return PlayerIdleState.new(_player)
    return null

func get_state_name() -> String:
    return "Walk"
# ============================================================================
# PLAYER IDLE STATE
# ============================================================================
# Estado de reposo del jugador
#
# DESIGN PATTERNS: State Pattern (Implementación concreta)
# ============================================================================

class_name PlayerIdleState
extends PlayerState

func enter() -> void:
    _player.velocity = Vector2.ZERO
    print(" Estado: IDLE")

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    # El jugador está quieto
    _player.velocity = Vector2.ZERO

func get_next_state() -> PlayerState:
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if input_dir.length() > 0.1:
        return PlayerWalkState.new(_player)
    return null

func get_state_name() -> String:
    return "Idle"
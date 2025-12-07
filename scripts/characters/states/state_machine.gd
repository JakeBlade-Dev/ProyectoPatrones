# ============================================================================
# STATE MACHINE
# ============================================================================
# MÃ¡quina de estados genÃ©rica para gestionar transiciones
#
# DESIGN PATTERNS: State Pattern (Context)
# SOLID: [SRP] Responsabilidad Ãºnica: Gestionar transiciones de estado
# ============================================================================

class_name StateMachine
extends Node

var _current_state: PlayerState
var _player: CharacterBody2D

signal state_changed(old_state: String, new_state: String)

func _init(player: CharacterBody2D, initial_state: PlayerState):
    _player = player
    _current_state = initial_state

func start() -> void:
    if _current_state:
        _current_state.enter()

func update(delta: float) -> void:
    if _current_state:
        _current_state.update(delta)
        _check_transition()

func physics_update(delta: float) -> void:
    if _current_state:
        _current_state.physics_update(delta)

func handle_input(event: InputEvent) -> void:
    if _current_state:
        _current_state.handle_input(event)

func _check_transition() -> void:
    var next_state = _current_state.get_next_state()
    if next_state != null:
        transition_to(next_state)

func transition_to(new_state: PlayerState) -> void:
    var old_state_name = _current_state.get_state_name() if _current_state else "None"
    
    if _current_state:
        _current_state.exit()
    
    _current_state = new_state
    _current_state.enter()
    
    state_changed.emit(old_state_name, _current_state.get_state_name())
    print("âœ… TransiciÃ³n: " + old_state_name + " âžœ " + _current_state.get_state_name())

func get_current_state_name() -> String:
    return _current_state.get_state_name() if _current_state else "None"
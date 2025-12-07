# ============================================================================
# COMMAND MANAGER
# ============================================================================
# Gestor centralizado de comandos con soporte para undo/redo
#
# DESIGN PATTERNS: Command Pattern + Memento Pattern
# SOLID: [SRP] Responsabilidad Ãºnica: Gestionar historial de comandos
# ============================================================================

class_name CommandManager
extends Node

## LÃ­mite de comandos en el historial
const MAX_HISTORY_SIZE = 50

var _command_history: Array = []
var _current_index: int = -1

signal command_executed(command: Command)
signal command_undone(command: Command)
signal command_redone(command: Command)

## Ejecuta un comando y lo agrega al historial
func execute_command(command: Command) -> void:
    command.execute()
    
    # Si hay comandos despuÃ©s del Ã­ndice actual, eliminarlos
    if _current_index < _command_history.size() - 1:
        _command_history = _command_history.slice(0, _current_index + 1)
    
    _command_history.append(command)
    _current_index += 1
    
    # Limitar tamaÃ±o del historial
    if _command_history.size() > MAX_HISTORY_SIZE:
        _command_history.pop_front()
        _current_index -= 1
    
    command_executed.emit(command)
    print("âœ… Comando ejecutado: " + command.get_description())

## Deshace el Ãºltimo comando
func undo() -> bool:
    if not can_undo():
        print(" No hay comandos para deshacer")
        return false
    
    var command = _command_history[_current_index]
    if command.is_reversible():
        command.undo()
        _current_index -= 1
        command_undone.emit(command)
        print(" Comando deshecho: " + command.get_description())
        return true
    else:
        print(" Comando no reversible: " + command.get_description())
        return false

## Rehace el comando deshecho
func redo() -> bool:
    if not can_redo():
        print(" No hay comandos para rehacer")
        return false
    
    _current_index += 1
    var command = _command_history[_current_index]
    command.execute()
    command_redone.emit(command)
    print(" Comando rehecho: " + command.get_description())
    return true

func can_undo() -> bool:
    return _current_index >= 0

func can_redo() -> bool:
    return _current_index < _command_history.size() - 1

func clear_history() -> void:
    _command_history.clear()
    _current_index = -1
    print(" Historial de comandos limpiado")

func get_history_size() -> int:
    return _command_history.size()

func get_current_index() -> int:
    return _current_index
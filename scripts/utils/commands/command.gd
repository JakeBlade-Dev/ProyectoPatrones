# ============================================================================
# COMMAND PATTERN (Base)
# ============================================================================
# Interfaz base para el patrón Command
#
# DESIGN PATTERNS APPLIED:
# ------------------------
# [Command Pattern] Patrón de Comportamiento
#       Encapsula una petición como un objeto, permitiendo parametrizar
#       clientes con diferentes peticiones, encolar o registrar peticiones,
#       y soportar operaciones reversibles.
#
# SOLID PRINCIPLES:
# -----------------
# [SRP] Single Responsibility - Cada comando hace una cosa específica
# [OCP] Open/Closed - Nuevos comandos sin modificar infraestructura
#
# Use Cases:
# - Sistema de deshacer/rehacer
# - Grabar y reproducir acciones del jugador
# - Macros y atajos personalizables
# ============================================================================

class_name Command
extends RefCounted

## Ejecuta el comando
func execute() -> void:
    pass

## Deshace el comando (si es reversible)
func undo() -> void:
    pass

## Verifica si el comando es reversible
func is_reversible() -> bool:
    return false

## Descripción del comando para debugging
func get_description() -> String:
    return "Command"
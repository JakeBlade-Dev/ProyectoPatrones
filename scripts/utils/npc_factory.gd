# ============================================================================
# NPC FACTORY
# ============================================================================
# Implementa el patrón Factory para creación centralizada de NPCs
#
# DESIGN PATTERNS APPLIED:
# ------------------------
# [Factory Pattern] Patrón de Creación
#       Encapsula la lógica de creación de objetos complejos.
#       Permite agregar nuevos tipos de NPCs sin modificar código cliente.
#
# SOLID PRINCIPLES:
# -----------------
# [OCP] Open/Closed Principle - Abierto para nuevos tipos, cerrado para modificación
# [DIP] Dependency Inversion - El cliente depende de la interfaz factory, no de clases concretas
#
# Benefits:
# - Centraliza la creación de NPCs
# - Facilita testing con NPCs mock
# - Reduce acoplamiento en el código cliente
# ============================================================================

class_name NPCFactory
extends Node

## Tipos de NPCs disponibles
enum NPCType {
    ASTRONAUT,
    KNIGHT,
    WIZARD,
    PENGUIN
}

## Configuración de cada tipo de NPC
const NPC_CONFIGS = {
    NPCType.ASTRONAUT: {
        "scene": "res://scenes/characters/astronauta.tscn",
        "name": "Astronauta",
        "interaction_text": "Presiona E para jugar\nSpace Invaders"
    },
    NPCType.KNIGHT: {
        "scene": "res://scenes/characters/caballero.tscn",
        "name": "Caballero",
        "interaction_text": "Presiona E para\niniciar la trivia"
    },
    NPCType.WIZARD: {
        "scene": "res://scenes/characters/mago.tscn",
        "name": "Mago",
        "interaction_text": "Presiona E para\ninteractuar"
    },
    NPCType.PENGUIN: {
        "scene": "res://scenes/characters/pinguino.tscn",
        "name": "Pingüino",
        "interaction_text": "Presiona E para\nhablar"
    }
}

## Crea un NPC del tipo especificado
## @param type: Tipo de NPC a crear (usar enum NPCType)
## @param position: Posición inicial del NPC en el mundo
## @returns: Instancia del NPC creado
static func create_npc(type: NPCType, position: Vector2 = Vector2.ZERO) -> Node:
    if not NPC_CONFIGS.has(type):
        push_error("Tipo de NPC no reconocido: " + str(type))
        return null
    
    var config = NPC_CONFIGS[type]
    var npc_scene = load(config["scene"])
    
    if not npc_scene:
        push_error("No se pudo cargar la escena: " + config["scene"])
        return null
    
    var npc = npc_scene.instantiate()
    npc.position = position
    # El nombre ya está configurado en la escena
    
    print(" NPC creado: " + config["name"] + " en " + str(position))
    return npc

## Crea múltiples NPCs a partir de una configuración
## @param npc_list: Array de diccionarios {type: NPCType, position: Vector2}
## @returns: Array de NPCs creados
static func create_multiple_npcs(npc_list: Array) -> Array:
    var npcs = []
    for npc_data in npc_list:
        var npc = create_npc(npc_data["type"], npc_data.get("position", Vector2.ZERO))
        if npc:
            npcs.append(npc)
    return npcs

## Obtiene la configuración de un tipo de NPC
static func get_npc_config(type: NPCType) -> Dictionary:
    return NPC_CONFIGS.get(type, {})
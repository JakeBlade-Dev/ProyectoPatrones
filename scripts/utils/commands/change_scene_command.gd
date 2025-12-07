# ============================================================================
# CHANGE SCENE COMMAND (Ejemplo)
# ============================================================================
# Comando para cambiar de escena con posibilidad de deshacer
#
# DESIGN PATTERNS: Command Pattern (Implementación concreta)
# ============================================================================

class_name ChangeSceneCommand
extends Command

var _scene_path: String
var _previous_scene_path: String
var _tree: SceneTree

func _init(tree: SceneTree, scene_path: String):
    _tree = tree
    _scene_path = scene_path
    _previous_scene_path = _tree.current_scene.scene_file_path if _tree.current_scene else ""

func execute() -> void:
    _tree.change_scene_to_file(_scene_path)

func undo() -> void:
    if _previous_scene_path != "":
        _tree.change_scene_to_file(_previous_scene_path)

func is_reversible() -> bool:
    return _previous_scene_path != ""

func get_description() -> String:
    return "Cambiar escena a: " + _scene_path
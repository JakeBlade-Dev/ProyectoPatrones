# ============================================================================
# SESSION MANAGER
# ============================================================================
# Verifica si el usuario está autenticado y redirige según corresponda
# ============================================================================

extends Node

func _ready():
	# Verificar si el usuario está logueado
	if not AuthManager.is_user_logged_in():
		# Si no está logueado, ir a login
		print("User not logged in, redirecting to login...")
		get_tree().change_scene_to_file("res://scenes/ui/login.tscn")

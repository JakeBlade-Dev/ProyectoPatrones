# ============================================================================
# MENU SESSION GUARD
# ============================================================================
# Se agrega a la escena del menú para verificar autenticación
# y proporcionar opción de cerrar sesión
# ============================================================================

extends Control

@onready var user_info_label: Label = $UserInfoLabel
@onready var logout_button: Button = $LogoutButton

func _ready():
	# Verificar si el usuario está autenticado
	if not AuthManager.is_user_logged_in():
		print("No active session, redirecting to login...")
		get_tree().change_scene_to_file("res://scenes/ui/login.tscn")
		return
	
	# Mostrar información del usuario
	var username = AuthManager.get_current_username()
	var is_admin = AuthManager.is_current_user_admin()
	
	if user_info_label:
		var role_text = " (Admin)" if is_admin else ""
		user_info_label.text = "👤 " + username + role_text
	
	if logout_button:
		logout_button.pressed.connect(_on_logout_pressed)

func _on_logout_pressed():
	AuthManager.logout()
	get_tree().change_scene_to_file("res://scenes/ui/login.tscn")

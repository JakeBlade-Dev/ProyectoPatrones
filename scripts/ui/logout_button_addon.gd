# ============================================================================
# LOGOUT BUTTON ADDON
# ============================================================================
# Agrega un botón de logout al menú existente sin modificar el menú original
# Agregar este script como hijo del nodo raíz del menú
# ============================================================================

extends Control

func _ready():
	# Verificar sesión
	if not AuthManager.is_user_logged_in():
		get_tree().change_scene_to_file("res://scenes/ui/login.tscn")
		return
	
	# Crear botón de logout
	create_logout_button()
	
	# Crear label de usuario
	create_user_label()

func create_logout_button():
	var logout_btn = Button.new()
	logout_btn.name = "LogoutButton"
	logout_btn.text = "Cerrar Sesión"
	logout_btn.position = Vector2(get_viewport_rect().size.x - 150, 20)
	logout_btn.size = Vector2(130, 40)
	logout_btn.pressed.connect(_on_logout_pressed)
	add_child(logout_btn)

func create_user_label():
	var user_label = Label.new()
	user_label.name = "UserLabel"
	
	var username = AuthManager.get_current_username()
	var is_admin = AuthManager.is_current_user_admin()
	var role = " [Admin]" if is_admin else ""
	
	user_label.text = "👤 " + username + role
	user_label.position = Vector2(get_viewport_rect().size.x - 150, 5)
	user_label.add_theme_font_size_override("font_size", 14)
	add_child(user_label)

func _on_logout_pressed():
	print("Logging out...")
	AuthManager.logout()
	get_tree().change_scene_to_file("res://scenes/ui/login.tscn")

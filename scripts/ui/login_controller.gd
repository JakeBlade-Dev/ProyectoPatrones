# ============================================================================
# LOGIN SCENE CONTROLLER
# ============================================================================
# Maneja la interfaz de usuario para login
# ============================================================================

extends Control

# ============================================================================
# NODE REFERENCES
# ============================================================================
@onready var username_input: LineEdit = $Panel/VBoxContainer/UsernameContainer/UsernameInput
@onready var password_input: LineEdit = $Panel/VBoxContainer/PasswordContainer/PasswordInput
@onready var login_button: Button = $Panel/VBoxContainer/LoginButton
@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var attempts_label: Label = $Panel/VBoxContainer/AttemptsLabel
@onready var admin_panel: Panel = $AdminPanel

# ============================================================================
# STATE
# ============================================================================
var current_username: String = ""
const USER_DATA_PATH = "res://data/users_data.json"

# ============================================================================
# INITIALIZATION
# ============================================================================
func _ready():
	print("=== LOGIN SCENE READY ===")
	
	# Cargar datos persistentes
	load_users_data()
	
	# Conectar señales de botones
	login_button.pressed.connect(_on_login_button_pressed)
	username_input.text_submitted.connect(_on_username_submitted)
	password_input.text_submitted.connect(_on_password_submitted)
	
	# Configurar controles
	password_input.secret = true
	message_label.text = ""
	attempts_label.text = ""
	admin_panel.visible = false
	
	# Focus en el campo de usuario
	username_input.grab_focus()
	
	print("Login credentials:")
	print("  Admin: username='admin', password='admin123'")
	print("  User: username='usuario', password='usuario123'")

# ============================================================================
# SIGNAL HANDLERS
# ============================================================================
func _on_login_button_pressed():
	attempt_login()

func _on_username_submitted(_text: String):
	password_input.grab_focus()

func _on_password_submitted(_text: String):
	attempt_login()



# ============================================================================
# LOGIN LOGIC
# ==================================================================

# Sistema de autenticación local con persistencia
# Estructura: {"password": str, "admin": bool, "locked": bool, "attempts": int, "lock_count": int}
var users_db = {
	"usuario": {"password": "usuario123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
    "jugador": {"password": "jugador123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
	"jugador2": {"password": "jugador123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
	"jugador3": {"password": "jugador123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
    "jonathan": {"password": "jonathan123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
	"josue": {"password": "josue123", "admin": false, "locked": false, "attempts": 0, "lock_count": 0},
	
	"admin": {"password": "admin123", "admin": true, "locked": false, "attempts": 0, "lock_count": 0}
}

# ============================================================================
# PERSISTENCIA DE DATOS
# ============================================================================
func load_users_data():
	print("Cargando datos de usuarios desde: ", USER_DATA_PATH)
	
	if not FileAccess.file_exists(USER_DATA_PATH):
		print("Archivo no existe, creando datos por defecto...")
		save_users_data()
		return
	
	var file = FileAccess.open(USER_DATA_PATH, FileAccess.READ)
	if file == null:
		print("ERROR: No se pudo abrir el archivo de usuarios")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("ERROR: No se pudo parsear JSON")
		return
	
	var loaded_data = json.data
	if typeof(loaded_data) == TYPE_DICTIONARY:
		# Actualizar users_db con datos guardados
		for username in loaded_data.keys():
			if users_db.has(username):
				# Actualizar datos existentes preservando la contraseña predefinida
				var saved_user = loaded_data[username]
				users_db[username].locked = saved_user.get("locked", false)
				users_db[username].attempts = saved_user.get("attempts", 0)
				users_db[username].lock_count = saved_user.get("lock_count", 0)
		print("Datos de usuarios cargados exitosamente")
	else:
		print("ERROR: Formato de datos inválido")

func save_users_data():
	print("Guardando datos de usuarios...")
	
	var file = FileAccess.open(USER_DATA_PATH, FileAccess.WRITE)
	if file == null:
		print("ERROR: No se pudo crear/abrir archivo para guardar")
		return
	
	var json_string = JSON.stringify(users_db, "\t")
	file.store_string(json_string)
	file.close()
	
	print("Datos guardados exitosamente en: ", USER_DATA_PATH)

func attempt_login():
	var username = username_input.text.strip_edges()
	var password = password_input.text
	
	print("=== ATTEMPT LOGIN ===")
	print("Username: ", username)
	print("Password: ", password)
	
	# Validar entrada
	if username.is_empty():
		message_label.add_theme_color_override("font_color", Color.YELLOW)
		message_label.text = "Ingresa un nombre de usuario"
		return
	
	if password.is_empty():
		message_label.add_theme_color_override("font_color", Color.YELLOW)
		message_label.text = "Ingresa una contraseña"
		return
	
	# Verificar si el usuario existe
	if not users_db.has(username):
		message_label.add_theme_color_override("font_color", Color.RED)
		message_label.text = "Usuario no encontrado"
		return
	
	var user_data = users_db[username]
	
	# Verificar si está bloqueado
	if user_data.locked:
		message_label.add_theme_color_override("font_color", Color.RED)
		
		# Verificar si es bloqueo permanente (segunda vez o más)
		if user_data.lock_count >= 2:
			message_label.text = "Cuenta bloqueada permanentemente"
			attempts_label.add_theme_color_override("font_color", Color.RED)
			attempts_label.text = "Esta cuenta no puede ser desbloqueada"
		else:
			message_label.text = "Cuenta bloqueada"
			attempts_label.add_theme_color_override("font_color", Color.RED)
			attempts_label.text = "Solo el administrador puede desbloquearla"
		return
	
	# Verificar contraseña
	if password == user_data.password:
		# LOGIN EXITOSO
		print("Login exitoso!")
		user_data.attempts = 0  # Resetear intentos
		save_users_data()  # Guardar estado
		
		message_label.add_theme_color_override("font_color", Color.GREEN)
		message_label.text = "Bienvenido, " + username + "!"
		attempts_label.text = ""
		
		# Guardar usuario actual
		current_username = username
		
		# Si es admin, mostrar panel
		if user_data.admin:
			print("Usuario es admin, mostrando panel...")
			show_admin_panel()
		else:
			print("Usuario normal, cambiando a menú...")
			# Cambiar a menú después de un breve delay
			get_tree().create_timer(0.3).timeout.connect(change_scene_to_menu)
	else:
		# CONTRASEÑA INCORRECTA
		print("Contraseña incorrecta")
		user_data.attempts += 1
		var remaining = 3 - user_data.attempts
		
		if user_data.attempts >= 3:
			# BLOQUEAR CUENTA
			user_data.locked = true
			user_data.lock_count += 1  # Incrementar contador de bloqueos
			
			message_label.add_theme_color_override("font_color", Color.RED)
			attempts_label.add_theme_color_override("font_color", Color.RED)
			
			if user_data.lock_count >= 2:
				# BLOQUEO PERMANENTE (segunda vez o más)
				message_label.text = "Cuenta bloqueada permanentemente"
				attempts_label.text = "Esta cuenta ya no puede ser desbloqueada"
			else:
				# PRIMER BLOQUEO (puede desbloquearse)
				message_label.text = "Cuenta bloqueada"
				attempts_label.text = "Has superado el límite de intentos"
			
			save_users_data()  # Guardar estado de bloqueo
		else:
			# Mostrar intentos restantes
			message_label.add_theme_color_override("font_color", Color.RED)
			message_label.text = "Contraseña incorrecta"
			attempts_label.add_theme_color_override("font_color", Color.ORANGE)
			attempts_label.text = "Intentos restantes: " + str(remaining)
			save_users_data()  # Guardar intentos
		
		# Limpiar contraseña
		password_input.text = ""
		password_input.grab_focus()

func change_scene_to_menu():
	print("Cambiando a escena del menú...")
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

# ============================================================================
# ADMIN PANEL
# ============================================================================
func show_admin_panel():
	admin_panel.visible = true
	$Panel.visible = false
	
	# Actualizar lista de usuarios
	update_user_list()

func update_user_list():
	var user_list_container = $AdminPanel/VBoxContainer/ScrollContainer/UserListContainer
	
	# Limpiar lista anterior
	for child in user_list_container.get_children():
		child.queue_free()
	
	# Agregar usuarios desde la base de datos local
	for username in users_db.keys():
		var user_data = users_db[username]
		var user_row = HBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = username
		name_label.custom_minimum_size = Vector2(150, 0)
		user_row.add_child(name_label)
		
		var status_label = Label.new()
		if user_data.locked:
			if user_data.lock_count >= 2:
				status_label.text = "Bloqueado permanente"
				status_label.add_theme_color_override("font_color", Color.DARK_RED)
			else:
				status_label.text = "Bloqueado"
				status_label.add_theme_color_override("font_color", Color.RED)
		else:
			status_label.text = "Activo"
			status_label.add_theme_color_override("font_color", Color.GREEN)
		status_label.custom_minimum_size = Vector2(200, 0)
		user_row.add_child(status_label)
		
		var role_label = Label.new()
		role_label.text = "ADMIN" if user_data.admin else "Usuario"
		role_label.custom_minimum_size = Vector2(100, 0)
		user_row.add_child(role_label)
		
		# Botón de desbloqueo (solo si no es bloqueo permanente)
		if user_data.locked and username != "admin":
			if user_data.lock_count < 2:
				# Solo puede desbloquearse en el primer bloqueo
				var unlock_button = Button.new()
				unlock_button.text = "Desbloquear"
				unlock_button.pressed.connect(func(): unlock_user(username))
				user_row.add_child(unlock_button)
			else:
				# Bloqueo permanente, no se puede desbloquear
				var permanent_label = Label.new()
				permanent_label.text = "No desbloqueable"
				permanent_label.add_theme_color_override("font_color", Color.DARK_RED)
				user_row.add_child(permanent_label)
		
		user_list_container.add_child(user_row)

func unlock_user(username: String):
	if users_db.has(username):
		var user_data = users_db[username]
		
		# Verificar que no sea bloqueo permanente
		if user_data.lock_count >= 2:
			var msg_label = $AdminPanel/VBoxContainer.get_node_or_null("MessageLabel")
			if msg_label:
				msg_label.add_theme_color_override("font_color", Color.RED)
				msg_label.text = "Usuario '" + username + "' tiene bloqueo permanente"
			return
		
		# Desbloquear (solo primer bloqueo)
		users_db[username].locked = false
		users_db[username].attempts = 0
		save_users_data()  # Guardar cambios
		update_user_list()
		
		var msg_label = $AdminPanel/VBoxContainer.get_node_or_null("MessageLabel")
		if msg_label:
			msg_label.add_theme_color_override("font_color", Color.GREEN)
			msg_label.text = "Usuario '" + username + "' desbloqueado (bloqueos: " + str(user_data.lock_count) + "/2)"

func _on_continue_button_pressed():
	# Ir al menú principal
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_logout_button_pressed():
	current_username = ""
	$Panel.visible = true
	admin_panel.visible = false
	username_input.text = ""
	password_input.text = ""
	message_label.text = ""
	attempts_label.text = ""
	username_input.grab_focus()

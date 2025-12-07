# ============================================================================
# AUTH MANAGER (Sistema de Autenticación)
# ============================================================================
# Gestiona autenticación de usuarios, roles y bloqueo de cuentas
#
# DESIGN PATTERNS: Singleton (via Autoload)
# SOLID: [SRP] Responsabilidad única: Gestionar autenticación y seguridad
# ============================================================================

extends Node

# ============================================================================
# SIGNALS
# ============================================================================
signal login_successful(username: String, is_admin: bool)
signal login_failed(attempts_remaining: int)
signal account_locked(username: String)
signal account_unlocked(username: String)

# ============================================================================
# CONSTANTS
# ============================================================================
const MAX_LOGIN_ATTEMPTS = 3
const SAVE_FILE_PATH = "user://auth_data.save"

# ============================================================================
# USER DATA STRUCTURE
# ============================================================================
class UserData:
	var username: String
	var password_hash: String
	var is_admin: bool
	var is_locked: bool
	var failed_attempts: int
	
	func _init(user: String, pass: String, admin: bool = false):
		username = user
		password_hash = pass.sha256_text()  # Hash de la contraseña
		is_admin = admin
		is_locked = false
		failed_attempts = 0
	
	func to_dict() -> Dictionary:
		return {
			"username": username,
			"password_hash": password_hash,
			"is_admin": is_admin,
			"is_locked": is_locked,
			"failed_attempts": failed_attempts
		}
	
	static func from_dict(data: Dictionary) -> UserData:
		var user = UserData.new(data.get("username", ""), "")
		user.password_hash = data.get("password_hash", "")
		user.is_admin = data.get("is_admin", false)
		user.is_locked = data.get("is_locked", false)
		user.failed_attempts = data.get("failed_attempts", 0)
		return user

# ============================================================================
# STATE VARIABLES
# ============================================================================
var users: Dictionary = {}  # username -> UserData
var current_user: String = ""
var is_logged_in: bool = false
var current_user_is_admin: bool = false

# ============================================================================
# INITIALIZATION
# ============================================================================
func _ready():
	print("=== AUTH MANAGER INITIALIZED ===")
	load_users()
	
	# Si no hay usuarios, crear los usuarios por defecto
	if users.is_empty():
		create_default_users()

func create_default_users():
	"""Crear usuarios por defecto: admin y usuario normal"""
	print("Creating default users...")
	
	# Usuario administrador
	var admin = UserData.new("admin", "admin123", true)
	users["admin"] = admin
	
	# Usuario normal
	var user = UserData.new("usuario", "usuario123", false)
	users["usuario"] = user
	
	save_users()
	print("✅ Default users created:")
	print("   - Admin: username='admin', password='admin123'")
	print("   - User: username='usuario', password='usuario123'")

# ============================================================================
# AUTHENTICATION METHODS
# ============================================================================
func attempt_login(username: String, password: String) -> bool:
	"""Intenta iniciar sesión con las credenciales proporcionadas"""
	print("Login attempt for user: ", username)
	
	# Verificar si el usuario existe
	if not users.has(username):
		print("❌ User not found: ", username)
		login_failed.emit(MAX_LOGIN_ATTEMPTS)
		return false
	
	var user: UserData = users[username]
	
	# Verificar si la cuenta está bloqueada
	if user.is_locked:
		print("🔒 Account is locked: ", username)
		account_locked.emit(username)
		return false
	
	# Verificar contraseña
	var password_hash = password.sha256_text()
	print("Password hash generated: ", password_hash.substr(0, 10), "...")
	print("Expected hash: ", user.password_hash.substr(0, 10), "...")
	
	if user.password_hash == password_hash:
		# Login exitoso
		user.failed_attempts = 0
		current_user = username
		is_logged_in = true
		current_user_is_admin = user.is_admin
		save_users()
		
		print("✅ Login successful: ", username)
		if user.is_admin:
			print("   Role: ADMIN")
		else:
			print("   Role: USER")
		
		print("Emitting login_successful signal...")
		login_successful.emit(username, user.is_admin)
		print("Signal emitted!")
		return true
	else:
		# Contraseña incorrecta
		user.failed_attempts += 1
		var attempts_remaining = MAX_LOGIN_ATTEMPTS - user.failed_attempts
		
		print("❌ Wrong password. Attempts remaining: ", attempts_remaining)
		
		if user.failed_attempts >= MAX_LOGIN_ATTEMPTS:
			user.is_locked = true
			print("🔒 Account locked after ", MAX_LOGIN_ATTEMPTS, " failed attempts")
			account_locked.emit(username)
		
		save_users()
		login_failed.emit(attempts_remaining)
		return false

func logout():
	"""Cerrar sesión del usuario actual"""
	print("Logging out user: ", current_user)
	current_user = ""
	is_logged_in = false
	current_user_is_admin = false

func unlock_account(username: String) -> bool:
	"""Desbloquea una cuenta (solo admin puede hacer esto)"""
	if not current_user_is_admin:
		print("❌ Only admin can unlock accounts")
		return false
	
	if not users.has(username):
		print("❌ User not found: ", username)
		return false
	
	var user: UserData = users[username]
	user.is_locked = false
	user.failed_attempts = 0
	save_users()
	
	print("✅ Account unlocked: ", username)
	account_unlocked.emit(username)
	return true

# ============================================================================
# USER MANAGEMENT
# ============================================================================
func get_all_users() -> Array:
	"""Retorna lista de todos los usuarios (solo para admin)"""
	if not current_user_is_admin:
		return []
	
	var user_list = []
	for username in users.keys():
		var user: UserData = users[username]
		user_list.append({
			"username": username,
			"is_admin": user.is_admin,
			"is_locked": user.is_locked,
			"failed_attempts": user.failed_attempts
		})
	return user_list

func is_user_locked(username: String) -> bool:
	"""Verifica si una cuenta está bloqueada"""
	if users.has(username):
		return users[username].is_locked
	return false

func get_failed_attempts(username: String) -> int:
	"""Obtiene el número de intentos fallidos de un usuario"""
	if users.has(username):
		return users[username].failed_attempts
	return 0

# ============================================================================
# PERSISTENCE (Guardar/Cargar)
# ============================================================================
func save_users():
	"""Guarda los datos de usuarios en disco"""
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		print("❌ Error saving users: ", FileAccess.get_open_error())
		return
	
	var save_data = {}
	for username in users.keys():
		save_data[username] = users[username].to_dict()
	
	file.store_var(save_data)
	file.close()
	print("💾 Users saved to disk")

func load_users():
	"""Carga los datos de usuarios desde disco"""
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No saved users found, will create defaults")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		print("❌ Error loading users: ", FileAccess.get_open_error())
		return
	
	var save_data = file.get_var()
	file.close()
	
	if save_data is Dictionary:
		for username in save_data.keys():
			users[username] = UserData.from_dict(save_data[username])
		print("✅ Users loaded from disk: ", users.keys())

# ============================================================================
# GETTERS
# ============================================================================
func get_current_username() -> String:
	return current_user

func is_current_user_admin() -> bool:
	return current_user_is_admin

func is_user_logged_in() -> bool:
	return is_logged_in

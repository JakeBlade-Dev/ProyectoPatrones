# ============================================================================
# GAME SERVICES
# ============================================================================
# Autoload que inicializa y registra todos los servicios del juego
#
# DESIGN PATTERNS: Service Locator + Dependency Injection
# SOLID: [SRP] Responsabilidad Ãºnica: Inicializar servicios
# ============================================================================

extends Node

func _ready():
	print("=== INICIALIZANDO SERVICIOS DEL JUEGO ===")
	_register_services()
	print("=== SERVICIOS INICIALIZADOS ===")

func _register_services():
	# Registrar Question Bank
	var question_bank = TriviaQuestionBank.new()
	add_child(question_bank)
	ServiceLocator.register_service("QuestionBank", question_bank)
	
	# Registrar Command Manager
	var command_manager = CommandManager.new()
	add_child(command_manager)
	ServiceLocator.register_service("CommandManager", command_manager)
	
	# Registrar Trivia Strategies
	var solitaire_strategy = TriviaSolitaireStrategy.new()
	ServiceLocator.register_service("TriviaSolitaireStrategy", solitaire_strategy)
	
	var multiplayer_strategy = TriviaMultiplayerStrategy.new()
	ServiceLocator.register_service("TriviaMultiplayerStrategy", multiplayer_strategy)
	
	print(" Servicios registrados en ServiceLocator")

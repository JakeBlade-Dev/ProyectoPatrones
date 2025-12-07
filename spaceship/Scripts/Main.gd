extends Node2D

# SeÃ±ales
signal score_changed(score)
signal lives_changed(lives)  
signal game_over_signal

# Variables del juego
var score: int = 0
var lives: int = 3
var level: int = 1
var enemies_defeated: int = 0
var game_active: bool = false

# Escenas - verificar que las rutas sean correctas
var player_scene = preload("res://spaceship/scenes/Player.tscn")
var enemy_scene = preload("res://spaceship/scenes/Enemy.tscn")
var hud_scene = preload("res://spaceship/scenes/HUD.tscn")

# Nodos
var player: Area2D
var enemies_container: Node2D
var bullets_container: Node2D
var enemy_bullets_container: Node2D
var hud: Node2D  # HUD es un Node2D segÃºn HUD.gd

# ConfiguraciÃ³n de enemigos
const ENEMY_ROWS = 5
const ENEMY_COLS = 11
const ENEMY_SPACING_X = 60
const ENEMY_SPACING_Y = 50
const ENEMY_START_X = 100
const ENEMY_START_Y = 100

# ConfiguraciÃ³n de movimiento de enemigos - SIMPLIFICADO PARA DEBUG
var enemy_direction: int = 1
var enemy_move_timer: float = 0.0
var enemy_move_speed: float = 1.0  # Movimiento cada segundo para debug fÃ¡cil
var enemy_drop_distance: float = 20.0
var enemy_move_distance: float = 20.0  # Movimiento mÃ¡s visible

# Timer para disparo enemigo - SIMPLIFICADO PARA DEBUG
var enemy_shoot_timer: float = 0.0
var enemy_shoot_interval: float = 3.0  # Disparo menos frecuente para reducir spam de debug

func _ready():
	print("=== MAIN SCENE STARTING ===")
	print("Godot version: ", Engine.get_version_info())
	print("Scene tree ready: ", is_inside_tree())
	print("Starting setup_game()...")
	await setup_game()
	print("=== GAME SETUP COMPLETED ===")

func setup_game():
	print("=== GAME SETUP STARTED ===")
	print("Scene children before setup: ", get_child_count())
	
	# Limpiar cualquier contenido previo
	for child in get_children():
		print("Removing existing child: ", child.name)
		child.queue_free()
	
	# Esperar dos frames para asegurar limpieza completa
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Crear contenedores primero
	print("Creating enemies container...")
	enemies_container = Node2D.new()
	enemies_container.name = "Enemies"
	enemies_container.z_index = 5  # Enemigos en capa base
	add_child(enemies_container)
	
	bullets_container = Node2D.new()
	bullets_container.name = "Bullets"
	bullets_container.z_index = 20  # Balas por encima de todo
	add_child(bullets_container)
	
	enemy_bullets_container = Node2D.new()
	enemy_bullets_container.name = "EnemyBullets"
	enemy_bullets_container.z_index = 15  # Balas enemigas en capa intermedia
	add_child(enemy_bullets_container)
	
	# CORREGIR LA POSICIÃ“N DEL JUGADOR
	print("Creating player...")
	player = player_scene.instantiate()
	
	# POSICIÃ“N CORRECTA: CENTRADO EN LA PARTE INFERIOR (ventana 846px)
	player.position = Vector2(423, 550)  # Centro X (846/2), parte inferior Y
	player.z_index = 10  # Jugador en capa intermedia
	add_child(player)
	
	print("Player positioned correctly at: ", player.position)
	
	# Conectar seÃ±ales del jugador
	player.bullet_fired.connect(_on_player_bullet_fired)
	player.player_hit.connect(_on_player_hit)
	
	# Crear HUD DESPUÃ‰S del jugador
	print("Creating HUD...")
	hud = hud_scene.instantiate()
	
	# VERIFICAR SI EL HUD TIENE PLAYERS O ENEMIGOS ANIDADOS
	var hud_players = []
	var hud_enemies = []
	find_players_in_node(hud, hud_players)
	find_enemies_in_node(hud, hud_enemies)
	
	if hud_players.size() > 0:
		print("WARNING: Found ", hud_players.size(), " Player(s) in HUD scene!")
		for hud_player in hud_players:
			print("Removing duplicate player from HUD: ", hud_player.name)
			hud_player.queue_free()
	
	if hud_enemies.size() > 0:
		print("WARNING: Found ", hud_enemies.size(), " Enemy(s) in HUD scene!")
		for hud_enemy in hud_enemies:
			print("Removing duplicate enemy from HUD: ", hud_enemy.name, " at ", hud_enemy.position)
			hud_enemy.queue_free()
	
	# Posicionar el HUD en una capa superior para evitar superposiciÃ³n
	hud.z_index = 100  # Capa superior
	add_child(hud)
	print("HUD created and positioned at z_index 100")
	
	# Conectar seÃ±ales del HUD
	score_changed.connect(hud._on_score_changed)
	lives_changed.connect(hud._on_lives_changed)
	game_over_signal.connect(hud._on_game_over)
	
	# Asegurar que el mensaje de Game Over estÃ© oculto al inicio
	if hud.has_method("hide_game_over"):
		hud.hide_game_over()
	
	# Crear enemigos
	print("Creating enemies...")
	create_enemies()
	
	# Esperar un frame para que los enemigos se inicializen completamente
	await get_tree().process_frame
	
	# Verificar que los enemigos se crearon correctamente
	var final_count = enemies_container.get_child_count()
	print("=== ENEMIES CREATION VERIFICATION ===")
	print("Expected enemies: ", ENEMY_ROWS * ENEMY_COLS)
	print("Actual enemies created: ", final_count)
	if final_count != ENEMY_ROWS * ENEMY_COLS:
		print("ERROR: Enemy count mismatch!")
	
	# Inicializar valores del HUD
	score_changed.emit(score)
	lives_changed.emit(lives)
	
	# VERIFICACIÃ“N FINAL: Asegurar que solo hay elementos Ãºnicos
	var all_players = []
	var all_enemies = []
	find_all_players_in_scene(all_players)
	find_all_enemies_in_scene(all_enemies)
	
	print("=== FINAL VERIFICATION ===")
	print("Total Players found in scene: ", all_players.size())
	print("Total Enemies found in scene: ", all_enemies.size())
	print("Enemies in container: ", enemies_container.get_child_count())
	
	if all_players.size() > 1:
		print("ERROR: Multiple Players detected!")
		for i in range(all_players.size()):
			var p = all_players[i]
			print("Player ", i, ": ", p.name, " at ", p.position, " parent: ", p.get_parent().name)
			
		# Remover Players duplicados, mantener solo el nuestro
		for p in all_players:
			if p != player:
				print("Removing duplicate player: ", p.name)
				p.queue_free()
	
	# Verificar enemigos duplicados o fuera del contenedor
	if all_enemies.size() > enemies_container.get_child_count():
		print("ERROR: Enemies outside container detected!")
		var container_enemies = enemies_container.get_children()
		for enemy in all_enemies:
			if not enemy in container_enemies:
				print("Removing enemy outside container: ", enemy.name, " at ", enemy.position, " parent: ", enemy.get_parent().name)
				enemy.queue_free()
	
	game_active = true
	print("Game setup complete! Player at: ", player.position)

func create_enemies():
	print("=== CREATING ENEMIES - DEBUG VERSION ===")
	print("Target: ", ENEMY_ROWS, " rows x ", ENEMY_COLS, " cols = ", ENEMY_ROWS * ENEMY_COLS, " enemies")
	print("Enemy scene path: ", enemy_scene)
	print("Enemies container: ", enemies_container)
	
	if not enemy_scene:
		print("ERROR: enemy_scene is null!")
		return
		
	if not enemies_container:
		print("ERROR: enemies_container is null!")
		return
	
	# Crear todas las filas de enemigos
	print("Creating all enemy rows...")
	var created_count = 0
	
	for row in ENEMY_ROWS:
		for col in ENEMY_COLS:
			print("Creating enemy ", created_count + 1, "...")
			
			var enemy = enemy_scene.instantiate()
			if not enemy:
				print("ERROR: Failed to instantiate enemy!")
				continue
				
			var x_pos = ENEMY_START_X + col * ENEMY_SPACING_X
			var y_pos = ENEMY_START_Y + row * ENEMY_SPACING_Y
			enemy.position = Vector2(x_pos, y_pos)
			
			# Configurar tipo de enemigo segÃºn la fila
			if row == 0:
				enemy.setup_enemy("top", 30)
			elif row <= 2:
				enemy.setup_enemy("middle", 20)
			else:
				enemy.setup_enemy("bottom", 10)
			
			enemies_container.add_child(enemy)
			print("Added enemy to container")
			
			# Conectar seÃ±ales
			if enemy.has_signal("enemy_destroyed"):
				enemy.enemy_destroyed.connect(_on_enemy_destroyed)
			if enemy.has_signal("enemy_bullet_fired"):
				enemy.enemy_bullet_fired.connect(_on_enemy_bullet_fired)
			
			created_count += 1
			if created_count <= 5 or created_count % 11 == 0:  # Mostrar primeros 5 y cada fila completa
				print("Enemy ", created_count, " successfully created at (", x_pos, ", ", y_pos, ")")
			
			# DEBUG: Verificar que no hay enemigos en la misma posiciÃ³n
			var overlapping_enemies = []
			for existing in enemies_container.get_children():
				if existing != enemy and existing.position.distance_to(enemy.position) < 5:
					overlapping_enemies.append(existing)
			
			if overlapping_enemies.size() > 0:
				print("WARNING: Enemy overlap detected at ", enemy.position)
				print("  - New enemy: ", enemy.name)
				for overlap in overlapping_enemies:
					print("  - Overlapping with: ", overlap.name, " at ", overlap.position)
				
				# Remover enemigos duplicados
				for overlap in overlapping_enemies:
					print("  - Removing overlapping enemy: ", overlap.name)
					overlap.queue_free()
	
	print("=== ENEMIES CREATION COMPLETE ===")
	print("Container children: ", enemies_container.get_child_count())
	
	# Verificar duplicados y posiciones problemÃ¡ticas
	detect_enemy_issues()
	
	# Verificar cada enemigo creado
	print("=== ENEMY VERIFICATION ===")
	for i in range(min(10, enemies_container.get_child_count())):  # Mostrar primeros 10
		var enemy = enemies_container.get_child(i)
		print("Enemy ", i, ": ", enemy.name, " at ", enemy.position, " valid: ", is_instance_valid(enemy))
		
		# Verificar si el enemigo tiene el script correcto
		if enemy.has_method("setup_enemy"):
			print("  - Has setup_enemy method: YES")
		else:
			print("  - Has setup_enemy method: NO - PROBLEM!")
	print("==========================")

func _process(delta):
	# Permitir salir con ESC en cualquier momento
	if Input.is_action_just_pressed("ui_cancel"):
		return_to_main_menu()
		return
	
	if not game_active:
		return
	
	# DEBUG: Verificar enemigos cada 2 segundos
	if Engine.get_process_frames() % 120 == 0:  # Cada 2 segundos aprox
		debug_enemy_status()
	
	# Mover enemigos
	move_enemies(delta)
	
	# Hacer que los enemigos disparen
	enemy_shooting_logic(delta)

func debug_enemy_status():
	var enemy_count = enemies_container.get_child_count() if enemies_container else 0
	print("=== ENEMY DEBUG ===")
	print("Active enemies: ", enemy_count)
	if enemy_count > 0 and enemy_count < 10:  # Solo mostrar posiciones si hay pocos
		for i in range(enemy_count):
			var enemy = enemies_container.get_child(i)
			print("Enemy ", i, " at: ", enemy.position)
	print("Game active: ", game_active)
	print("===================")

func move_enemies(delta):
	if not enemies_container:
		print("ERROR: enemies_container is null!")
		return
		
	var enemies = enemies_container.get_children()
	if enemies.size() == 0:
		print("No enemies to move")
		return
	
	# DEBUG OCASIONAL: Verificar si hay enemigos fuera del contenedor
	if Engine.get_process_frames() % 300 == 0:  # Cada 5 segundos aprox
		var all_enemies_in_scene = []
		find_all_enemies_in_scene(all_enemies_in_scene)
		if all_enemies_in_scene.size() != enemies.size():
			print("WARNING: Enemy count mismatch!")
			print("  - In container: ", enemies.size())
			print("  - In scene: ", all_enemies_in_scene.size())
			print("  - Missing enemies may be static!")
		
	enemy_move_timer += delta
	
	# Comprobar si es momento de mover
	if enemy_move_timer >= enemy_move_speed:
		enemy_move_timer = 0.0
		
		print("=== MOVING ", enemies.size(), " ENEMIES ===")
		
		# Movimiento simple para debug
		var move_amount = enemy_direction * enemy_move_distance
		var moved_count = 0  # Declarar la variable aquÃ­
		
		# Verificar lÃ­mites (ventana real: 846px de ancho)
		var will_hit_edge = false
		for enemy in enemies:
			var next_x = enemy.position.x + move_amount
			if next_x < 30 or next_x > 816:  # Ajustado para ventana de 846px
				will_hit_edge = true
				break
		
		if will_hit_edge:
			# Cambiar direcciÃ³n y bajar
			enemy_direction *= -1
			print("Changing direction to: ", enemy_direction, " and dropping")
			for enemy in enemies:
				if is_instance_valid(enemy):
					enemy.position.y += enemy_drop_distance
					moved_count += 1
		else:
			# Mover horizontalmente
			print("Moving enemies by: ", move_amount)
			var static_enemies = []
			
			for i in range(enemies.size()):
				var enemy = enemies[i]
				if is_instance_valid(enemy):  # Verificar que el enemigo es vÃ¡lido
					var old_pos = enemy.position
					enemy.position.x += move_amount
					moved_count += 1
					
					# Verificar si realmente se moviÃ³
					if abs(enemy.position.x - old_pos.x) < 0.1:  # No se moviÃ³
						static_enemies.append(i)
					
					# Debug para enemigos problemÃ¡ticos
					if moved_count <= 3:
						print("Enemy ", moved_count, " moved from ", old_pos, " to ", enemy.position)
			
			# Reportar enemigos estÃ¡ticos
			if static_enemies.size() > 0:
				print("WARNING: ", static_enemies.size(), " enemies did not move!")
				for idx in static_enemies:
					if idx < enemies.size():
						var stuck_enemy = enemies[idx]
						print("  - Static enemy at index ", idx, " position: ", stuck_enemy.position)
				
		# Mostrar algunas posiciones para debug
		if enemies.size() > 0:
			print("Total enemies moved: ", moved_count, "/", enemies.size())
			print("First enemy at: ", enemies[0].position)
			if enemies.size() > 1:
				print("Last enemy at: ", enemies[-1].position)

func enemy_shooting_logic(delta):
	var enemies = enemies_container.get_children()
	if enemies.size() == 0:
		return
		
	enemy_shoot_timer += delta
	
	# Los enemigos disparan cada cierto intervalo
	if enemy_shoot_timer >= enemy_shoot_interval:
		enemy_shoot_timer = 0.0
		
		# Elegir un enemigo aleatorio para disparar
		var random_enemy = enemies[randi() % enemies.size()]
		random_enemy.shoot()
		print("Enemy shooting from position: ", random_enemy.position)

func _on_player_bullet_fired(bullet_scene, pos):
	var bullet = bullet_scene.instantiate()
	bullet.position = pos
	bullets_container.add_child(bullet)
	bullet.bullet_hit.connect(_on_bullet_hit)
	print("Player bullet fired at: ", pos)

func _on_enemy_bullet_fired(bullet_scene, pos):
	var bullet = bullet_scene.instantiate()
	bullet.position = pos
	enemy_bullets_container.add_child(bullet)
	print("Enemy bullet fired at: ", pos)

func _on_bullet_hit(bullet):
	# Verificar colisiÃ³n con enemigos
	var enemies = enemies_container.get_children()
	for enemy in enemies:
		if bullet.global_position.distance_to(enemy.global_position) < 25:
			enemy.destroy()
			bullet.queue_free()
			print("Enemy hit and destroyed!")
			return

func _on_enemy_destroyed(points):
	score += points
	enemies_defeated += 1
	score_changed.emit(score)
	
	print("Enemy destroyed! Score: ", score, " Remaining enemies: ", enemies_container.get_child_count() - 1)
	
	# Verificar si se eliminaron todos los enemigos
	var remaining_enemies = enemies_container.get_child_count() - 1
	if remaining_enemies <= 0:
		print("All enemies defeated! Next level!")
		next_level()

func next_level():
	level += 1
	enemies_defeated = 0
	print("=== LEVEL COMPLETE ===")
	print("Starting level ", level)
	
	await get_tree().create_timer(2.0).timeout
	
	# Resetear posiciÃ³n de enemigos y crear nueva formaciÃ³n
	enemy_direction = 1
	enemy_move_timer = 0.0
	enemy_shoot_timer = 0.0
	
	create_enemies()

func _on_player_hit():
	if not game_active:
		return  # Ignorar hits si el juego no estÃ¡ activo
		
	lives -= 1
	print("=== PLAYER HIT ===")
	print("Lives remaining: ", lives)
	
	lives_changed.emit(lives)
	
	# Actualizar el estado visual del jugador segÃºn las vidas restantes
	if player and player.has_method("update_damage_visual"):
		player.update_damage_visual(lives)
	
	if lives <= 0:
		print("All lives lost!")
		# Deshabilitar controles del jugador
		if player and player.has_method("disable_controls"):
			player.disable_controls()
		end_game()
	else:
		print("Lives left: ", lives)
		print("==================")

func end_game():
	print("=== GAME OVER ===")
	print("Final score: ", score)
	print("Level reached: ", level)
	print("Press R to restart")
	print("================")
	
	game_active = false
	game_over_signal.emit()
	
	# Detener todos los movimientos y disparos
	enemy_move_timer = 0.0
	enemy_shoot_timer = 0.0

func restart_game():
	print("=== RESTARTING GAME ===")
	print("Cleaning up scene...")
	
	# Limpiar todos los elementos del juego
	if enemies_container:
		for enemy in enemies_container.get_children():
			enemy.queue_free()
	if bullets_container:
		for bullet in bullets_container.get_children():
			bullet.queue_free()
	if enemy_bullets_container:
		for bullet in enemy_bullets_container.get_children():
			bullet.queue_free()
	if player:
		player.queue_free()
	if hud:
		hud.queue_free()
	
	# Limpiar contenedores
	if enemies_container:
		enemies_container.queue_free()
	if bullets_container:
		bullets_container.queue_free()
	if enemy_bullets_container:
		enemy_bullets_container.queue_free()
	
	# Reiniciar todas las variables
	print("Resetting game variables...")
	score = 0
	lives = 3
	level = 1
	enemies_defeated = 0
	enemy_direction = 1
	enemy_move_timer = 0.0
	enemy_move_speed = 1.0
	enemy_shoot_timer = 0.0
	enemy_shoot_interval = 3.0
	game_active = false
	
	# Limpiar referencias
	player = null
	enemies_container = null
	bullets_container = null
	enemy_bullets_container = null
	hud = null
	
	# Esperar a que se limpie todo
	await get_tree().process_frame
	await get_tree().process_frame
	
	print("Starting new game...")
	await setup_game()
	
	# Habilitar controles del jugador al reiniciar
	if player and player.has_method("enable_controls"):
		player.enable_controls()
	
	print("=== GAME RESTARTED ===")

func find_players_in_node(node: Node, player_list: Array):
	"""Buscar recursivamente Players anidados en un nodo"""
	for child in node.get_children():
		if child.get_script() and child.get_script().get_path() == "res://spaceship/scenes/Player.tscn":
			player_list.append(child)
			print("Found nested Player: ", child.name, " at ", child.position)
		elif child is Area2D and child.has_signal("bullet_fired"):
			# Detectar Players por sus seÃ±ales caracterÃ­sticas
			player_list.append(child)
			print("Found Player-like Area2D: ", child.name, " at ", child.position)
		
		# Buscar recursivamente en los hijos
		find_players_in_node(child, player_list)

func find_enemies_in_node(node: Node, enemy_list: Array):
	"""Buscar recursivamente Enemies anidados en un nodo"""
	for child in node.get_children():
		if child.get_script() and child.get_script().get_path() == "res://spaceship/Scripts/Enemy.gd":
			enemy_list.append(child)
			print("Found nested Enemy: ", child.name, " at ", child.position)
		elif child.has_method("setup_enemy"):
			# Detectar Enemies por su mÃ©todo caracterÃ­stico
			enemy_list.append(child)
			print("Found Enemy-like node: ", child.name, " at ", child.position)
		
		# Buscar recursivamente en los hijos
		find_enemies_in_node(child, enemy_list)

func find_all_players_in_scene(player_list: Array):
	"""Encontrar todos los Players en toda la escena"""
	find_players_in_node(self, player_list)

func detect_enemy_issues():
	"""Detectar enemigos duplicados, estÃ¡ticos o problemÃ¡ticos"""
	print("=== ENEMY ISSUE DETECTION ===")
	
	var enemies = enemies_container.get_children()
	var position_map = {}
	var duplicate_positions = []
	var enemies_outside_container = []
	
	# 1. Detectar enemigos en posiciones duplicadas
	for enemy in enemies:
		var pos_key = str(enemy.position.x) + "," + str(enemy.position.y)
		if position_map.has(pos_key):
			duplicate_positions.append(enemy.position)
			print("DUPLICATE POSITION: ", enemy.position, " - Enemy: ", enemy.name)
		else:
			position_map[pos_key] = enemy
	
	# 2. Buscar enemigos fuera del contenedor (enemigos "perdidos")
	find_enemies_outside_container(self, enemies_outside_container)
	
	if enemies_outside_container.size() > 0:
		print("ENEMIES OUTSIDE CONTAINER: ", enemies_outside_container.size())
		for lost_enemy in enemies_outside_container:
			print("  - Lost enemy at: ", lost_enemy.position, " parent: ", lost_enemy.get_parent().name)
			# Mover al contenedor correcto o eliminar
			lost_enemy.get_parent().remove_child(lost_enemy)
			enemies_container.add_child(lost_enemy)
			print("  - Moved to enemies_container")
	
	# 3. Verificar enemigos con script incorrecto
	for enemy in enemies:
		if not enemy.has_method("setup_enemy"):
			print("ENEMY WITHOUT SETUP: ", enemy.name, " - may be static")
	
	print("==============================")

func find_enemies_outside_container(node: Node, enemy_list: Array):
	"""Buscar recursivamente enemigos fuera del contenedor"""
	for child in node.get_children():
		# Si es un enemigo pero no estÃ¡ en el contenedor de enemigos
		if child != enemies_container and child.has_method("setup_enemy"):
			enemy_list.append(child)
		elif child != enemies_container:
			# Buscar recursivamente, pero no dentro del contenedor de enemigos
			find_enemies_outside_container(child, enemy_list)

func find_all_enemies_in_scene(enemy_list: Array):
	"""Encontrar TODOS los enemigos en toda la escena"""
	find_all_enemies_recursive(self, enemy_list)

func find_all_enemies_recursive(node: Node, enemy_list: Array):
	"""BÃºsqueda recursiva de enemigos en toda la escena"""
	for child in node.get_children():
		if child.has_method("setup_enemy") or (child.get_script() and child.get_script().get_path() == "res://spaceship/Scripts/Enemy.gd"):
			enemy_list.append(child)
		find_all_enemies_recursive(child, enemy_list)

func return_to_main_menu():
	"""Volver al menÃº principal del spaceship game"""
	print("Returning to main menu...")
	get_tree().change_scene_to_file("res://spaceship/scenes/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("restart"):
		if not game_active:
			print("Restart key pressed - restarting game...")
			restart_game()
		else:
			print("Restart key pressed during active game - ignored")
			print("(Game Over is required before restart)")
	
	# Debug: Mostrar estado actual cuando se presiona R
	if event.is_action_pressed("restart"):
		print("Game state: active=", game_active, " lives=", lives, " score=", score)
	
	# Salir del minijuego y regresar al mundo principal con ESC
	if event.is_action_pressed("ui_cancel"):
		print("ESC pressed - returning to main world...")
		get_tree().change_scene_to_file("res://mundo.tscn")

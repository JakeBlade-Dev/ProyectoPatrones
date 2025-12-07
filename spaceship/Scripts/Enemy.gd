extends Area2D

# SeÃ±ales
signal enemy_destroyed(points)
signal enemy_bullet_fired(bullet_scene, position)

# Variables
var enemy_type: String = "bottom"
var points: int = 10
var bullet_scene = preload("res://spaceship/scenes/EnemyBullet.tscn")

# Referencias a nodos
var sprite_node: Sprite2D
var collision_node: CollisionShape2D

func _ready():
	print("Enemy _ready() started")
	
	# Obtener referencias a los nodos con find_child
	sprite_node = find_child("Sprite2D")
	collision_node = find_child("CollisionShape2D")
	
	# Crear nodos si no existen
	if not sprite_node:
		sprite_node = Sprite2D.new()
		sprite_node.name = "Sprite2D"
		add_child(sprite_node)
		print("Created Sprite2D for enemy")
		
	if not collision_node:
		collision_node = CollisionShape2D.new()
		collision_node.name = "CollisionShape2D"
		add_child(collision_node)
		print("Created CollisionShape2D for enemy")
	
	# Conectar seÃ±al de colisiÃ³n
	connect("area_entered", _on_area_entered)
	
	print("Enemy ready, waiting for setup...")

func setup_enemy(type: String, enemy_points: int):
	enemy_type = type
	points = enemy_points
	
	if not sprite_node or not collision_node:
		print("ERROR: Enemy nodes not found even after creation!")
		return
	
	# Crear sprite del enemigo
	create_enemy_sprite(type)
	
	# Configurar colisiÃ³n al 70% del tamaÃ±o visual
	var shape = RectangleShape2D.new()
	# 70% del tamaÃ±o visual del enemigo
	shape.size = Vector2(30 * 0.7, 20 * 0.7)  # 21x14 pixels
	collision_node.shape = shape
	
	print("Enemy created: ", type, " with ", points, " points at ", position)

func create_enemy_sprite(type: String):
	if not sprite_node:
		print("ERROR: sprite_node is null in create_enemy_sprite!")
		return
		
	# Configurar color segÃºn el tipo
	var color: Color
	match type:
		"top":
			color = Color.RED
		"middle":
			color = Color.YELLOW
		"bottom":
			color = Color.CYAN
		_:
			color = Color.WHITE
	
	# Crear imagen
	var image = Image.create(30, 20, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# Crear textura desde la imagen
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	# Asignar textura al sprite
	sprite_node.texture = texture
	
	print("Enemy sprite created: ", type, " color: ", color)

func shoot():
	emit_signal("enemy_bullet_fired", bullet_scene, position + Vector2(0, 15))
	print("Enemy shot fired from ", position)

func destroy():
	print("Enemy destroyed for ", points, " points")
	emit_signal("enemy_destroyed", points)
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_bullets"):
		area.queue_free()
		destroy()

extends Control

# AnfitriÃ³n de la trivia: crea sala, mantiene lista de jugadores, distribuye preguntas y calcula puntajes.

signal player_list_updated(players)
signal game_started()
signal game_ended(results)
signal room_created(room_id)

var room_id: String = ""
var rooms := {} # room_id -> {host_peer, players: {peer_id: {name, score}}, settings: {questions_per_player, categories}}

# temporary per-connection mapping: peer_id -> room_id
var peer_room := {}

var players := {} # global mapping peer_id -> {peer_id, name, score}

var questions_per_player := 10
var categories := []
var questions_map := {} # peer_id -> questions assigned

var network = null
var qdata = null

func _ready():
	# UI elements in the scene should be connected to these methods
	# init helpers
	network = preload("res://multiplayer/trivia_network.gd").new()
	qdata = preload("res://multiplayer/questions_data.gd")

	# if this Control is the scene root, try to auto-wire common UI nodes (if exist)
	if has_node("VBox/LineNumeroPreguntas"):
		$VBox/Categorias.clear()
		# llenar categorias desde data
		for k in qdata.QUESTIONS.keys():
			$VBox/Categorias.add_item(str(k))
		$VBox/LineNumeroPreguntas.text = str(questions_per_player)
	# conectar seÃ±ales (si el editor no lo hizo)
	if has_node("VBox/CrearBoton"):
		$VBox/CrearBoton.connect("pressed", Callable(self, "_on_crear_pressed"))
		# if a Close button is present, connect it (optional)
		if has_node("VBox/CloseButton"):
			$VBox/CloseButton.connect("pressed", Callable(self, "_on_close_pressed"))
	if has_node("VBox/StartButton"):
		$VBox/StartButton.connect("pressed", Callable(self, "_on_start_pressed"))

	# mostrar lista inicial vacÃ­a
	if has_node("VBox/RoomIdLabel"):
		$VBox/RoomIdLabel.text = "Room ID: -"

	print("TriviaHost ready")
	_update_ui_status("Listo")
	_update_players_list()

func _update_ui_status(msg:String):
	# show a message in the scene if the node exists
	if has_node("Mensaje"):
		$Mensaje.text = str(msg)
	else:
		print("[UI]", msg)

func _update_room_id_label():
	if has_node("VBox/RoomIdLabel"):
		if room_id != "":
			$VBox/RoomIdLabel.text = "Room ID: %s" % room_id
		else:
			$VBox/RoomIdLabel.text = "Room ID: -"

func _update_players_list():
	if has_node("VBox/PlayersList"):
		$VBox/PlayersList.clear()
		# list players currently known
		for pid in players.keys():
			var p = players[pid]
			$VBox/PlayersList.add_item(str(p.get("name", "Jugador-%s" % pid)))

func _on_crear_pressed():
	var num = int($VBox/LineNumeroPreguntas.text)
	var cats := []
	for i in range($VBox/Categorias.get_item_count()):
		if $VBox/Categorias.is_selected(i):
			cats.append($VBox/Categorias.get_item_text(i))
	if cats.size() == 0:
		$Mensaje.text = "Selecciona al menos una categoria"
		return
	create_room(num, cats)
	_update_room_id_label()
	_update_ui_status("Sala creada: %s" % room_id)
	# if CloseButton exists, show it
	if has_node("VBox/CloseButton"):
		$VBox/CloseButton.show()

func _on_start_pressed():
	if players.size() == 0:
		$Mensaje.text = "No hay jugadores conectados"
		return
	start_game()

func create_room(num_questions:int, cats:Array, port:int = 9000, max_clients:int = 8):
	# store settings
	questions_per_player = num_questions
	categories = cats.duplicate()
	# create a room id
	room_id = network.make_room_id()
	emit_signal("room_created", room_id)
	print("Room created:", room_id, "questions_per_player:", questions_per_player, "categories:", categories)
	# Crear servidor ENet para LAN
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port, max_clients)
	if err != OK:
		print("Failed to start ENet server:", err)
		_update_ui_status("Error al iniciar servidor: %d" % err)
		return
	get_tree().network_peer = peer
	# Conectar seÃ±ales
	peer.connect("peer_connected", Callable(self, "_on_network_peer_connected"))
	peer.connect("peer_disconnected", Callable(self, "_on_network_peer_disconnected"))
	$Mensaje.text = "Servidor iniciado en puerto %d" % port
	_update_ui_status("Servidor iniciado en puerto %d" % port)

	# registrar sala en el host con owner = get_tree().get_network_unique_id() (0 for server local)
	var rid = room_id
	rooms[rid] = {"host_peer":0, "players":{}, "settings": {"questions_per_player":questions_per_player, "categories":categories}}
	print("Registered room:", rid)
	_update_room_id_label()
	_update_players_list()

func get_player_list() -> Array:
	var out = []
	for pid in players.keys():
		out.append(players[pid])
	return out

# LÃ³gica para cuando un cliente se une (esto debe llamarse desde callback de red)
func _on_player_join(peer_id:int, name:String):
	# Join default behavior: assign to no room
	print("_on_player_join called for", peer_id, name)
	_update_ui_status("Jugador conectado: %s (%d)" % [name, peer_id])
	# add to players map if not present
	if not players.has(peer_id):
		players[peer_id] = {"peer_id": peer_id, "name": name, "score": 0}
	_update_players_list()

func _on_player_leave(peer_id:int):
	if peer_room.has(peer_id):
		var rid = peer_room[peer_id]
		if rooms.has(rid):
			var pmap = rooms[rid]["players"]
			if pmap.has(peer_id):
				pmap.erase(peer_id)
	if peer_room.has(peer_id):
		peer_room.erase(peer_id)
	print("player left", peer_id)
	_update_ui_status("Jugador desconectado: %d" % peer_id)
	_update_players_list()

func start_game():
	# Asignar preguntas aleatorias a cada jugador segÃºn las categorias y preguntas_per_player
	questions_map.clear()
	for pid in players.keys():
		var assigned := []
		# tomar aleatoriamente de cada categoria hasta completar preguntas_per_player
		var per_cat = max(1, int(questions_per_player / max(1, categories.size())))
		for c in categories:
			var qs = qdata.get_random_questions(c, per_cat)
			for q in qs:
				assigned.append(q)
		# si faltan, rellenar con preguntas al azar de la primera categorÃ­a
		if assigned.size() < questions_per_player and categories.size() > 0:
			var extra = qdata.get_random_questions(categories[0], questions_per_player - assigned.size())
			for q in extra:
				assigned.append(q)
		assigned.shuffle()
		questions_map[pid] = assigned
		# Enviar preguntas al jugador (RPC/Network)
		_send_questions_to_player(pid, assigned)
	emit_signal("game_started")
	print("Game started. Questions sent to players.")
	_update_ui_status("Partida iniciada. Preguntas enviadas.")

func list_rooms() -> Array:
	var out = []
	for rid in rooms.keys():
		out.append({"room_id":rid, "players": rooms[rid]["players"].size(), "settings": rooms[rid]["settings"]})
	return out

func _on_close_pressed():
	# UI handler for closing the current room
	close_room()

func close_room():
	if room_id == "":
		$Mensaje.text = "No hay sala activa"
		return
	# remove room from registry and stop server
	if rooms.has(room_id):
		rooms.erase(room_id)
		print("Room removed:", room_id)
		room_id = ""
		# stop ENet server if running
		if get_tree().network_peer != null:
			get_tree().network_peer = null
		$VBox/RoomIdLabel.text = "Room ID: -"
		$Mensaje.text = "Sala cerrada"
		emit_signal("room_created", "")

@rpc
func client_request_join_room(peer_id:int, room_id_req:String, player_name:String):
	# Called by client via rpc to request join
	print("client_request_join_room", peer_id, room_id_req, player_name)
	if not rooms.has(room_id_req):
		rpc_id(peer_id, "join_response", false, "Sala no encontrada")
		return
	var r = rooms[room_id_req]
	r["players"][peer_id] = {"peer_id":peer_id, "name":player_name, "score":0}
	peer_room[peer_id] = room_id_req
	# notify all players in room of updated list
	_broadcast_room_players(room_id_req)
	rpc_id(peer_id, "join_response", true, room_id_req)

func _broadcast_room_players(rid:String):
	if not rooms.has(rid):
		return
	var pmap = rooms[rid]["players"]
	var list = []
	for pid in pmap.keys():
		list.append(pmap[pid]["name"])
	# enviar lista a todos los peers del room
	for pid in pmap.keys():
		rpc_id(pid, "room_player_list", list)

func _send_questions_to_player(peer_id:int, questions:Array):
	var data = network.serialize_questions(questions)
	# Si hay un peer de red, usar rpc_id para enviar directamente
	if get_tree().network_peer != null:
		rpc_id(peer_id, "receive_questions", data)
	else:
		network.safe_rpc(peer_id, "receive_questions", [data])
	print("(host) sending %d questions to %d" % [questions.size(), peer_id])

# Este mÃ©todo serÃ¡ llamado por la red cuando el jugador envÃ­e su resultado parcial
@rpc
func receive_player_results(peer_id:int, result:Dictionary):
	# result puede contener {score:, times:[], answers:[]}
	if players.has(peer_id):
		players[peer_id]["score"] = result.get("score", 0)
	else:
		# si no existe, agregar (caso remoto)
		players[peer_id] = {"peer_id":peer_id, "name":"Jugador-%d" % peer_id, "score": result.get("score",0)}
	emit_signal("player_list_updated", get_player_list())
	print("Received results from", peer_id, result)

func end_game_and_show_podium():
	# calcular podium
	var arr = []
	for pid in players.keys():
		arr.append({"peer_id":pid, "name":players[pid].name if typeof(players[pid])==TYPE_OBJECT else players[pid]["name"], "score":players[pid]["score"]})
	arr.sort_custom(Callable(self, "_sort_scores"))
	emit_signal("game_ended", arr)
	print("Game ended. Podium:", arr)

func _sort_scores(a, b):
	return b.score - a.score

# Callbacks para networking (placeholders): deberÃ¡s conectarlos a los eventos reales del Peer
func _on_network_peer_connected(id):
	print("network connected:", id)
	# agregar jugador temporal con nombre por defecto
	players[id] = {"peer_id":id, "name":"Jugador-%d" % id, "score":0}
	emit_signal("player_list_updated", get_player_list())
	# si el host local tambiÃ©n quiere aparecer, usar id 1? (host id es 1 en ENet)
	# enviar room info al cliente si necesita


func _on_network_peer_disconnected(id):
	print("network disconnected:", id)
	if players.has(id):
		players.erase(id)
		emit_signal("player_list_updated", get_player_list())

# Utilities
func debug_print(msg):
	print("[TriviaHost]", msg)

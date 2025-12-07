extends Control

# Cliente de la trivia: unirse a sala, recibir preguntas, enviar respuestas y resultados

signal connected_to_room(room_id)
signal received_questions(questions)
signal game_results(results)

var network = null

var my_peer_id := -1
var room_id := ""
var player_name := "Jugador"
var my_questions := []
var my_score := 0

func _ready():
	# initialize network helper
	network = preload("res://multiplayer/trivia_network.gd").new()
	_update_status("Listo")

func _update_status(msg:String):
	if has_node("VBox/StatusLabel"):
		$VBox/StatusLabel.text = str(msg)
	else:
		print("[Client UI]", msg)

func _on_join_pressed():
	var ip = "127.0.0.1"
	var port = 9000
	var name = "Jugador"
	if has_node("VBox/IPLine"):
		ip = $VBox/IPLine.text if $VBox/IPLine.text != "" else ip
	if has_node("VBox/PortLine"):
		port = int($VBox/PortLine.text) if $VBox/PortLine.text != "" else port
	if has_node("VBox/NameLine"):
		name = $VBox/NameLine.text if $VBox/NameLine.text != "" else name
	_update_status("Conectando a %s:%d..." % [ip, port])
	join_room_by_ip(ip, port, name)

@rpc
func join_response(success:bool, data):
	if success:
		print("Join success, room:", data)
		_update_status("Unido a sala %s" % data)
		room_id = str(data)
		if has_node("VBox/RoomIdLine"):
			$VBox/RoomIdLine.text = room_id
	else:
		print("Join failed:", data)
		_update_status("Fallo al unirse: %s" % str(data))
		if has_node("Mensaje"):
			$Mensaje.text = str(data)

@rpc
func room_player_list(list_players:Array):
	print("Players in room:", list_players)
	_update_status("Jugadores en sala: %d" % list_players.size())
	if has_node("VBox/PlayersList"):
		$VBox/PlayersList.clear()
		for p in list_players:
			$VBox/PlayersList.add_item(str(p))

func join_room_by_ip(ip:String, port:int, name:String):
	player_name = name
	# Crear cliente ENet y conectar
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		print("Failed to create ENet client:", err)
		_update_status("Error al conectar: %d" % err)
		if has_node("Mensaje"):
			$Mensaje.text = "Error al crear cliente ENet: %d" % err
		return
	get_tree().network_peer = peer
	peer.connect("connection_succeeded", Callable(self, "_on_connected"))
	peer.connect("connection_failed", Callable(self, "_on_connection_failed"))
	peer.connect("server_disconnected", Callable(self, "_on_server_disconnected"))
	room_id = "%s:%d" % [ip, port]
	print("(client) connecting to", room_id)
	_update_status("Conectando...")

# Este mÃ©todo serÃ¡ llamado por el host via RPC: receive_questions(data)
@rpc
func receive_questions(data:Array):
	# data es una lista serializada de preguntas
	my_questions = data.duplicate()
	emit_signal("received_questions", my_questions)
	print("(client) received %d questions" % my_questions.size())
	_update_status("Recibidas %d preguntas" % my_questions.size())
	if has_node("Mensaje"):
		$Mensaje.text = "Recibidas %d preguntas" % my_questions.size()

func _on_connected():
	print("Connected to host")
	_update_status("Conectado al host")
	emit_signal("connected_to_room", room_id)
	# si el usuario escribiÃ³ un RoomId, pedir unirse
	if has_node("VBox/RoomIdLine") and $VBox/RoomIdLine.text.strip_edges() != "":
		var rid = $VBox/RoomIdLine.text.strip_edges()
		# llamar rpc al host (peer id 1) para solicitar uniÃ³n
		rpc_id(1, "client_request_join_room", get_tree().get_network_unique_id(), rid, player_name)

func _on_connection_failed():
	print("Connection failed")
	_update_status("ConexiÃ³n fallida")
	if has_node("Mensaje"):
		$Mensaje.text = "No se pudo conectar al host"

func _on_server_disconnected():
	print("Server disconnected")
	_update_status("Desconectado del host")
	if has_node("Mensaje"):
		$Mensaje.text = "El host cerrÃ³ la conexiÃ³n"

func send_answer(question_index:int, chosen:int, time_taken:float):
	# enviar respuesta al host (o guardarla localmente para enviar al final)
	# En este ejemplo acumulamos puntaje localmente
	if question_index >= 0 and question_index < my_questions.size():
		var q = my_questions[question_index]
		if q:
			if chosen == q.get("correcta", -1):
				my_score += 1

func send_results_to_host():
	var results = {"score": my_score}
	if get_tree().network_peer != null:
		# enviar al servidor (id 1 en ENet suele ser el servidor)
		rpc_id(1, "receive_player_results", get_tree().get_network_unique_id(), results)
	else:
		network.safe_rpc(1, "receive_player_results", [get_tree().get_network_unique_id(), results])
	print("(client) sent results", results)

func _on_game_results(results):
	emit_signal("game_results", results)
	print("(client) game results:", results)

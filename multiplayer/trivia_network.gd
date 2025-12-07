# Utilities and protocol helpers for trivia multiplayer
# This file provides common structures, serialization helpers and simple room id creation.

extends Node

signal debug(msg)

const ROOM_ID_CHARS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func _ready():
	pass

func make_room_id(length: int = 6) -> String:
	var r = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(length):
		r += ROOM_ID_CHARS[rng.randi_range(0, ROOM_ID_CHARS.length() - 1)]
	return r

# Serialize a question list to minimal dict form
func serialize_questions(questions: Array) -> Array:
	var out = []
	for q in questions:
		out.append({"pregunta": q.pregunta if typeof(q) == TYPE_OBJECT else q["pregunta"], "respuestas": q.respuestas, "correcta": q.correcta})
	return out

# Safe RPC call wrapper to avoid crashes if multiplayer not configured
func safe_rpc(target, method_name: String, params: Array = []):
	if get_tree().network_peer != null:
		# cannot call rpc here because this is a helper; caller should use rpc/rpc_id
		emit_signal("debug", "Would RPC -> %s : %s" % [str(target), method_name])
	else:
		emit_signal("debug", "Multiplayer API not available; skipping rpc")

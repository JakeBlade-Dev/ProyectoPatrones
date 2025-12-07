Instrucciones rápidas para probar el modo multijugador (LAN) - Godot 4.x

1) Abrir el proyecto en Godot Editor.
2) Abrir la escena `res://trivia_host.tscn` y ejecutar (Play Scene) para iniciar el host.
   - En la UI, selecciona categorías, número de preguntas y pulsa "Crear sala".
   - El servidor se iniciará en el puerto por defecto 9000.
3) En otra instancia del editor (o en otra máquina de la misma red), abrir `res://trivia_client.tscn` y ejecutar.
   - Introduce IP (ej: 127.0.0.1 para localhost) y puerto (9000) y pulsa "Unirse".
   - El cliente conectará vía ENet y mostrará el estado.
4) Desde el host, cuando haya jugadores conectados, pulsa "Iniciar partida". El host asignará preguntas y llamará `rpc_id(peer, "receive_questions", data)`.

Rooms y unir por ID:
- El host registra la(s) sala(s) creadas en memoria y cada sala tiene un `Room ID` generado.
- El cliente puede escribir el `Room ID` en el campo "ID de sala" para pedir unirse específicamente a esa sala.
- Al conectar el cliente, si hay un `Room ID` en el campo, el cliente enviará `rpc_id(1, "client_request_join_room", peer_id, room_id, player_name)` al host; el host responderá con `join_response(success, data)` y actualizará la lista de jugadores.
5) En este repositorio los RPCs están implementados de forma básica. Ajusta la lógica según tu flujo de UI y verás cómo los clientes reciben las preguntas y pueden enviar resultados.

Notas:
- Este código usa ENet y las RPCs de Godot. Asegúrate de usar Godot 4.x.
- Los métodos que necesitan ser adaptados al diseño final están marcados con comentarios TODO en los scripts bajo `multiplayer/`.

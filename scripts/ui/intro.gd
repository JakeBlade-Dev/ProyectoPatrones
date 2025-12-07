extends Control


func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# Ya no es necesario ajustar size ni position manualmente
	$VideoStreamPlayer.finished.connect(_on_video_finished)

func _on_video_finished():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

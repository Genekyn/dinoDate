extends Node

func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	var file_name = current_scene_file.get_file()
	var level_number_str = file_name.trim_prefix("level_").trim_suffix(".tscn")
	var current_level_number = level_number_str.to_int()
	
	# Afficher le numéro du niveau
	var game_manager = get_node("/root/GameManager")
	if game_manager and game_manager.has_method("set_level_label"):
		game_manager.set_level_label(current_level_number)
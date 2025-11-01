extends Node

@onready var level_label: Label = $levelLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
		
		# Extraire correctement le numéro du niveau
	var file_name = current_scene_file.get_file()  # "level_1.tscn"
	var level_number_str = file_name.trim_prefix("level_").trim_suffix(".tscn")  # "1"
	var current_level_number = level_number_str.to_int()
	level_label.text = "Level " + str(current_level_number)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

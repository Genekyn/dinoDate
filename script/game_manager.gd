# res://script/game_manager.gd
extends Node

@onready var level_label: Label = $levelLabel
var save_system
@export var levelChoices = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Créer une instance de SaveSystem si on n'utilise pas l'autoload
	save_system = load("res://script/save_system.gd").new()
	add_child(save_system)
	
	# Charger le dernier niveau sauvegardé
	var current_level_number = save_system.load_last_level()
	
	# Vérifier si le niveau actuel correspond au niveau sauvegardé
	var current_scene_file = get_tree().current_scene.scene_file_path
	var file_name = current_scene_file.get_file()
	var level_number_str = file_name.trim_prefix("level_").trim_suffix(".tscn")
	var scene_level_number = level_number_str.to_int()
	
	# Si on est pas sur le bon niveau, changer de scène
	if scene_level_number != current_level_number:
		var correct_level_path = "res://levels/level_%d.tscn" % current_level_number
		if ResourceLoader.exists(correct_level_path):
			get_tree().change_scene_to_file(correct_level_path)
		else:
			# Si le niveau sauvegardé n'existe pas, rester sur le niveau actuel
			level_label.text = "Level " + str(scene_level_number)
	else:
		# On est déjà sur le bon niveau
		level_label.text = "Level " + str(current_level_number)
# Gérer l'input pour redémarrer au niveau 1
func _input(event):
	if event.is_action_pressed("restartGame"):
		restart_from_level_one()

func restart_from_level_one():
	# Sauvegarder le niveau 1
	save_system.save_last_level(levelChoices)
	
	# Redémarrer au niveau 1
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	print("Redémarrage au niveau 1")

# res://script/save_system.gd
extends Node

const SAVE_PATH = "user://last_level.cfg"
func _ready() -> void:
	# Cette fonction est vide car c'est un autoload
	pass

static func save_last_level(level_number: int) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(str(level_number))
		print("Sauvegarde niveau ", level_number)

static func load_last_level() -> int:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var level = content.to_int()
		print("Chargement niveau sauvegardé: ", level)
		return level
	print("Aucune sauvegarde trouvée, niveau 1")
	return 1

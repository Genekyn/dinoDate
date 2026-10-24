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


# ---------- Progression (déblocages + pseudo) ----------
# last_level.cfg ci-dessus revient à 1 après le niveau 16 : il ne peut donc pas
# retenir ce qui est débloqué. On range la progression dans un 2e fichier.
# Un ConfigFile est un petit fichier texte rangé en [sections] et clés = valeurs,
# comme un .ini. Sur le Web, user:// est stocké dans le navigateur.
# Doc Godot : « ConfigFile » et « Data paths ».
const PROGRESS_PATH = "user://progress.cfg"
const DEFAULT_PLAYER_NAME = "Player"


func _load_progress() -> ConfigFile:
	var config := ConfigFile.new()
	config.load(PROGRESS_PATH)  # si le fichier n'existe pas encore, il reste vide
	return config


# Plus haut niveau réussi en mode normal (0 = aucun).
func get_highest_completed() -> int:
	var config := _load_progress()
	if config.has_section_key("progress", "highest_completed"):
		return config.get_value("progress", "highest_completed")
	# Joueur qui avait une partie avant cette mise à jour : si sa sauvegarde
	# est au niveau 5, c'est qu'il a réussi les niveaux 1 à 4.
	if FileAccess.file_exists(SAVE_PATH):
		return load_last_level() - 1
	return 0


func mark_level_completed(level_number: int) -> void:
	if level_number <= get_highest_completed():
		return  # déjà débloqué, rien à changer
	var config := _load_progress()
	config.set_value("progress", "highest_completed", level_number)
	config.save(PROGRESS_PATH)


# Contre-la-montre : un niveau est jouable s'il a été réussi en mode normal.
func is_level_unlocked(level_number: int) -> bool:
	return level_number <= get_highest_completed()


# Speedrun : débloqué quand les 16 niveaux ont été finis en mode normal.
func is_game_completed() -> bool:
	return _load_progress().get_value("progress", "game_completed", false)


func set_game_completed() -> void:
	var config := _load_progress()
	config.set_value("progress", "game_completed", true)
	config.save(PROGRESS_PATH)


func get_player_name() -> String:
	return _load_progress().get_value("player", "name", DEFAULT_PLAYER_NAME)


func set_player_name(player_name: String) -> void:
	var config := _load_progress()
	config.set_value("player", "name", player_name)
	config.save(PROGRESS_PATH)

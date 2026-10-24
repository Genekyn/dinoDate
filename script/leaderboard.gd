# res://script/leaderboard.gd
# Autoload "Leaderboard" : garde le top 10 des temps, en local.
# Les scores sont rangés par "catégorie" :
#   - "speedrun"            -> temps total des 16 niveaux
#   - "level_1" ... "level_16" -> meilleurs temps en contre-la-montre
# Chaque score est un Dictionary { "name": "Oli", "ms": 41230 }.
#
# Pour passer à un classement EN LIGNE plus tard, il suffira de modifier
# submit_score() et get_scores() : le reste du jeu ne passe que par elles.
extends Node

const SAVE_PATH := "user://leaderboard.cfg"
const MAX_ENTRIES := 10
const SPEEDRUN_CATEGORY := "speedrun"

var _file := ConfigFile.new()


func _ready() -> void:
	# On charge le fichier une seule fois au lancement (autoload = toujours là).
	_file.load(SAVE_PATH)


func level_category(level_number: int) -> String:
	return "level_%d" % level_number


# Renvoie la liste triée (le plus rapide en premier). Vide si aucun temps.
func get_scores(category: String) -> Array:
	return _file.get_value("scores", category, [])


# Ajoute un temps. Renvoie la place obtenue (0 = 1er), ou -1 si hors du top 10.
func submit_score(category: String, player_name: String, time_ms: int) -> int:
	var scores := get_scores(category)
	var entry := { "name": player_name, "ms": time_ms }
	scores.append(entry)
	# sort_custom trie avec notre propre règle : a passe avant b si son temps
	# est plus petit. "func(a, b): ..." est une fonction sans nom (lambda).
	scores.sort_custom(func(a, b): return a["ms"] < b["ms"])
	if scores.size() > MAX_ENTRIES:
		scores.resize(MAX_ENTRIES)  # on garde seulement les 10 premiers
	_file.set_value("scores", category, scores)
	_file.save(SAVE_PATH)
	return scores.find(entry)

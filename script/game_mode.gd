# res://script/game_mode.gd
# Autoload "GameMode" (déclaré dans Projet > Paramètres > Autoload).
# Un autoload est créé une seule fois au lancement du jeu et n'est JAMAIS
# détruit, même quand on change de scène ou qu'un niveau est rechargé
# après une mort. C'est pour ça qu'on y range :
#   - le mode de jeu en cours (normal, speedrun, contre-la-montre)
#   - le chrono (sinon il repartirait de zéro à chaque rechargement)
# N'importe quel script peut y accéder en écrivant GameMode.quelque_chose.
# Doc Godot : « Singletons (Autoload) ».
extends Node

# Un enum, c'est une liste de noms pour des valeurs fixes.
# Écrire Mode.SPEEDRUN est plus lisible (et sans faute de frappe possible)
# que d'écrire le texte "speedrun" un peu partout.
enum Mode { NORMAL, SPEEDRUN, TIME_ATTACK }

const LEVEL_PATH_FORMAT := "res://levels/level_%d.tscn"
const MAIN_MENU_PATH := "res://scenes/main_menu.tscn"
const LEVEL_SELECT_PATH := "res://scenes/level_select.tscn"
const LEADERBOARD_PATH := "res://scenes/leaderboard_screen.tscn"

var mode: Mode = Mode.NORMAL
# Contre-la-montre : true = on enchaîne sur le niveau suivant après une victoire
var chain_levels := false

# Le chrono se base sur Time.get_ticks_msec() : le nombre de millisecondes
# RÉELLES depuis le lancement du jeu. Contrairement au "delta" de _process,
# il n'est pas ralenti par Engine.time_scale (ralenti de mort / victoire).
var _start_ms := 0
var _stopped_ms := 0
var _timer_running := false


# ---------- Lancer un mode ----------
# Ces fonctions sont appelées par le menu et par l'écran de choix de niveau.

func start_normal(level_number: int) -> void:
	mode = Mode.NORMAL
	_timer_running = false
	_go_to(level_path(level_number))


func start_speedrun() -> void:
	mode = Mode.SPEEDRUN
	# On n'appelle PAS start_timer() ici : c'est le GameManager du niveau 1
	# qui le lance quand le niveau est vraiment chargé (voir game_manager.gd).
	_timer_running = false
	_go_to(level_path(1))


func start_time_attack(level_number: int, chain: bool) -> void:
	mode = Mode.TIME_ATTACK
	chain_levels = chain
	_timer_running = false
	_go_to(level_path(level_number))


func go_to_menu() -> void:
	mode = Mode.NORMAL
	_timer_running = false
	_go_to(MAIN_MENU_PATH)


func go_to_level_select() -> void:
	_timer_running = false
	_go_to(LEVEL_SELECT_PATH)


func _go_to(scene_path: String) -> void:
	# Si on quitte pendant un ralenti (mort ou victoire), on remet la vitesse
	# normale, sinon la scène suivante serait elle aussi au ralenti.
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file(scene_path)


# ---------- Chrono ----------

func start_timer() -> void:
	_start_ms = Time.get_ticks_msec()
	_timer_running = true


# Arrête le chrono et renvoie le temps final en millisecondes.
func stop_timer() -> int:
	_stopped_ms = Time.get_ticks_msec() - _start_ms
	_timer_running = false
	return _stopped_ms


func is_timer_running() -> bool:
	return _timer_running


# Temps écoulé : en direct si le chrono tourne, sinon le temps figé à l'arrêt.
func elapsed_ms() -> int:
	if _timer_running:
		return Time.get_ticks_msec() - _start_ms
	return _stopped_ms


# 83456 ms -> "01:23.45" (minutes:secondes.centièmes)
# Les divisions entre entiers sont voulues ici (on veut couper les décimales) :
# on coupe l'avertissement de Godot.
@warning_ignore("integer_division")
func format_time(ms: int) -> String:
	var minutes := ms / 60000
	var seconds := (ms / 1000) % 60
	var centiseconds := (ms / 10) % 100
	return "%02d:%02d.%02d" % [minutes, seconds, centiseconds]


# ---------- Niveaux ----------

func level_path(level_number: int) -> String:
	return LEVEL_PATH_FORMAT % level_number


# Compte les niveaux en cherchant level_1, level_2... jusqu'au premier absent.
# Ajouter un level_17.tscn suffit donc pour qu'il apparaisse partout.
func level_count() -> int:
	var count := 0
	while ResourceLoader.exists(level_path(count + 1)):
		count += 1
	return count


# "res://levels/level_7.tscn" -> 7 (0 si la scène n'est pas un niveau)
func level_number_of(scene: Node) -> int:
	var file_name := scene.scene_file_path.get_file()
	if not file_name.begins_with("level_"):
		return 0
	return file_name.trim_prefix("level_").trim_suffix(".tscn").to_int()

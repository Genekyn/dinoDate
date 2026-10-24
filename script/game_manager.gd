# res://script/game_manager.gd
# Présent dans chacun des 16 niveaux. Son _ready() s'exécute à chaque
# chargement du niveau, y compris après une mort (la killzone recharge
# toute la scène avec reload_current_scene()).
extends Node

const LABEL_SCREEN_POSITION := Vector2(40, 30)
const LABEL_FONT_SIZE := 48
# Le chrono s'affiche juste sous le numéro du niveau
const TIMER_LABEL_POSITION := Vector2(40, 90)

@onready var level_label: Label = $levelLabel
var _timer_label: Label


func _ready() -> void:
	_setup_hud()
	var level_number := GameMode.level_number_of(get_tree().current_scene)
	level_label.text = "Level " + str(level_number)

	# "match" = choisir un bloc de code selon la valeur (comme un switch).
	match GameMode.mode:
		GameMode.Mode.NORMAL:
			_redirect_to_saved_level(level_number)
		GameMode.Mode.SPEEDRUN:
			# Lancé une seule fois au niveau 1 : après une mort ou un changement
			# de niveau, le chrono tourne déjà, on ne le remet donc pas à zéro.
			if not GameMode.is_timer_running():
				GameMode.start_timer()
		GameMode.Mode.TIME_ATTACK:
			# Relancé à CHAQUE chargement : une mort remet donc le chrono à zéro.
			GameMode.start_timer()

	# Pas de chrono affiché en mode normal
	_timer_label.visible = GameMode.mode != GameMode.Mode.NORMAL


func _process(_delta: float) -> void:
	if _timer_label.visible:
		_timer_label.text = GameMode.format_time(GameMode.elapsed_ms())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("openMenu"):
		if GameMode.mode == GameMode.Mode.TIME_ATTACK:
			GameMode.go_to_level_select()
		else:
			# En speedrun, quitter = abandonner la run (aucun temps enregistré)
			GameMode.go_to_menu()


# Un CanvasLayer est un calque posé par-dessus le jeu : ce qui est dedans
# reste fixe à l'écran, peu importe la caméra et son zoom.
func _setup_hud() -> void:
	var hud := CanvasLayer.new()
	add_child(hud)
	level_label.reparent(hud, false)
	level_label.position = LABEL_SCREEN_POSITION
	level_label.add_theme_font_size_override("font_size", LABEL_FONT_SIZE)

	# Le label du chrono est créé par le code : comme ça, pas besoin de
	# l'ajouter à la main dans les 16 niveaux.
	_timer_label = Label.new()
	hud.add_child(_timer_label)
	_timer_label.position = TIMER_LABEL_POSITION
	_timer_label.add_theme_font_size_override("font_size", LABEL_FONT_SIZE)


# Mode normal : le bouton Continue charge le niveau 1, et on saute ici
# directement au niveau sauvegardé.
func _redirect_to_saved_level(level_number: int) -> void:
	var saved_level := SaveSystem.load_last_level()
	if saved_level == level_number:
		return
	var saved_path := GameMode.level_path(saved_level)
	if ResourceLoader.exists(saved_path):
		# call_deferred = "fais-le à la fin de l'image en cours". Changer de
		# scène pendant qu'elle est encore en train de se charger provoque
		# l'erreur "Parent node is busy".
		get_tree().change_scene_to_file.call_deferred(saved_path)

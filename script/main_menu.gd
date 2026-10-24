extends Control

# @onready : la variable est remplie au moment où la scène est prête.
# Le chemin après $ est celui du nœud dans l'arbre de main_menu.tscn.
@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var speedrun_button: Button = $VBoxContainer/SpeedrunButton
@onready var time_attack_button: Button = $VBoxContainer/TimeAttackButton
@onready var leaderboard_button: Button = $VBoxContainer/LeaderboardButton
@onready var name_edit: LineEdit = $VBoxContainer/NameEdit


func _ready() -> void:
	# Pas de fichier de sauvegarde = rien à continuer
	continue_button.disabled = not FileAccess.file_exists(SaveSystem.SAVE_PATH)

	# Déblocages (voir save_system.gd) :
	# - speedrun : les 16 niveaux finis en mode normal
	# - contre-la-montre : au moins un niveau réussi en mode normal
	speedrun_button.disabled = not SaveSystem.is_game_completed()
	if speedrun_button.disabled:
		speedrun_button.text = "SPEEDRUN (LOCKED)"
	time_attack_button.disabled = SaveSystem.get_highest_completed() == 0
	if time_attack_button.disabled:
		time_attack_button.text = "TIME ATTACK (LOCKED)"

	# Le pseudo enregistré est réaffiché ; "Player" s'il n'y en a pas.
	name_edit.text = SaveSystem.get_player_name()

	# Signaux : "quand ce bouton est pressé, appelle cette fonction".
	# Équivalent en code de l'onglet Nœud > Signaux de l'éditeur.
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	speedrun_button.pressed.connect(_on_speedrun_pressed)
	time_attack_button.pressed.connect(_on_time_attack_pressed)
	leaderboard_button.pressed.connect(_on_leaderboard_pressed)
	# text_changed est émis à chaque lettre tapée : on sauvegarde au fur et à mesure.
	name_edit.text_changed.connect(_on_name_changed)

	# Sans focus de départ, la manette n'a aucun bouton à sélectionner
	new_game_button.grab_focus()


func _on_new_game_pressed() -> void:
	SaveSystem.save_last_level(1)
	GameMode.start_normal(1)


func _on_continue_pressed() -> void:
	GameMode.start_normal(SaveSystem.load_last_level())


func _on_speedrun_pressed() -> void:
	GameMode.start_speedrun()


func _on_time_attack_pressed() -> void:
	GameMode.go_to_level_select()


func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file(GameMode.LEADERBOARD_PATH)


func _on_name_changed(new_text: String) -> void:
	var player_name := new_text.strip_edges()  # retire les espaces au début et à la fin
	if player_name.is_empty():
		player_name = SaveSystem.DEFAULT_PLAYER_NAME
	SaveSystem.set_player_name(player_name)

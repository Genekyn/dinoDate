extends Control

# Le GameManager du niveau 1 redirige vers le niveau sauvegardé
const FIRST_LEVEL_PATH := "res://levels/level_1.tscn"

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var leaderboard_button: Button = $VBoxContainer/LeaderboardButton



func _ready() -> void:
	# Pas de fichier de sauvegarde = rien à continuer
	continue_button.disabled = not FileAccess.file_exists(SaveSystem.SAVE_PATH)
	# Pas encore de temps enregistrés : activé à la tâche Scoreboard
	leaderboard_button.disabled = true

	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.grab_focus()  # Mettre le focus sur le bouton "New Game" par défaut

func _on_new_game_pressed() -> void:
	SaveSystem.save_last_level(1)
	get_tree().change_scene_to_file(FIRST_LEVEL_PATH)


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(FIRST_LEVEL_PATH)

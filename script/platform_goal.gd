# res://script/platform_goal.gd
extends Area2D
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var point_light_blue: PointLight2D = $AnimatableBody2D/PointLightBlue
@onready var point_light_yellow: PointLight2D = $AnimatableBody2D/PointLightYellow
@onready var point_light: PointLight2D = $AnimatableBody2D/PointLight
@export var sfx_almost_win : AudioStream
@export var sfx_win : AudioStream
@export var music_winAll : AudioStream
const FILE_BEGIN = "res://levels/level_"

var blueOnGoal := false
var orangeOnGoal := false

var first_level_path = "res://levels/level_1.tscn"
var next_level_path := ""
var _has_won := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_light_blue.enabled = false
	point_light_yellow.enabled = false
	point_light.enabled = false
	# Connect signals and reset goal state when scene is loaded
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
	_reset_goal_state()
func _reset_goal_state():
	blueOnGoal = false
	orangeOnGoal = false
	next_level_path = ""
	_has_won = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("blueDino"):
		blueOnGoal = true
		point_light_blue.enabled = true
		load_sfx(sfx_almost_win)
		%sfx_player.play()
		print ("Dino Bleu sur le goal")
	elif body.is_in_group("orangeDino"):
		orangeOnGoal = true
		point_light_yellow.enabled = true
		load_sfx(sfx_almost_win)
		%sfx_player.play()
		print ("Dino Orange sur le goal")
	win_game()
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("blueDino"):
		blueOnGoal = false
		point_light_blue.enabled = false
		print ("Dino Bleu n'est plus sur le goal")
	elif body.is_in_group("orangeDino"):
		orangeOnGoal = false
		point_light_yellow.enabled = false
		print ("Dino Orange n'est plus sur le goal")
func win_game():
	# _has_won évite de compter la victoire deux fois si un dino sort puis
	# revient sur le goal pendant le ralenti (sinon : 2 temps enregistrés).
	if not (blueOnGoal and orangeOnGoal) or _has_won:
		return
	_has_won = true
	point_light.enabled = true
	load_sfx(sfx_win)
	%sfx_player.play()

	var current_level_number := GameMode.level_number_of(get_tree().current_scene)
	var next_level_number := current_level_number + 1
	var has_next_level := ResourceLoader.exists(GameMode.level_path(next_level_number))

	# Chaque mode réagit différemment à la victoire (voir game_mode.gd)
	match GameMode.mode:
		GameMode.Mode.NORMAL:
			_win_normal(current_level_number, has_next_level)
		GameMode.Mode.SPEEDRUN:
			_win_speedrun(next_level_number, has_next_level)
		GameMode.Mode.TIME_ATTACK:
			_win_time_attack(current_level_number, next_level_number, has_next_level)

	# Ralenti de victoire, puis _on_timer_timeout() charge next_level_path
	Engine.time_scale = 0.1
	timer.start()


# Mode normal : comportement d'origine + on enregistre les déblocages.
func _win_normal(current_level_number: int, has_next_level: bool) -> void:
	SaveSystem.mark_level_completed(current_level_number)
	if has_next_level:
		SaveSystem.save_last_level(current_level_number + 1)
		next_level_path = GameMode.level_path(current_level_number + 1)
	else:
		# Les 16 niveaux sont finis : on débloque le speedrun
		SaveSystem.set_game_completed()
		SaveSystem.save_last_level(1)
		load_music(music_winAll)
		%sfx_music.play()
		# Retour au menu, où le Speedrun vient d'être débloqué
		next_level_path = GameMode.MAIN_MENU_PATH


# Speedrun : on enchaîne sans arrêter le chrono, et on enregistre à la fin.
func _win_speedrun(next_level_number: int, has_next_level: bool) -> void:
	if has_next_level:
		next_level_path = GameMode.level_path(next_level_number)
		return
	var total_ms := GameMode.stop_timer()
	Leaderboard.submit_score(Leaderboard.SPEEDRUN_CATEGORY, SaveSystem.get_player_name(), total_ms)
	load_music(music_winAll)
	%sfx_music.play()
	next_level_path = GameMode.LEADERBOARD_PATH  # on montre le classement


# Contre-la-montre : on enregistre le temps du niveau, puis soit on enchaîne
# (si l'option est cochée et que le niveau suivant est débloqué), soit on
# revient à l'écran de choix.
func _win_time_attack(current_level_number: int, next_level_number: int, has_next_level: bool) -> void:
	var level_ms := GameMode.stop_timer()
	Leaderboard.submit_score(Leaderboard.level_category(current_level_number), SaveSystem.get_player_name(), level_ms)
	if GameMode.chain_levels and has_next_level and SaveSystem.is_level_unlocked(next_level_number):
		next_level_path = GameMode.level_path(next_level_number)
	else:
		next_level_path = GameMode.LEVEL_SELECT_PATH


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else: 
		get_tree().change_scene_to_file(first_level_path)

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
		
func load_music(music_to_load):
	if %sfx_music.stream != music_to_load:
		%sfx_music.stop()
		%sfx_music.stream = music_to_load
	

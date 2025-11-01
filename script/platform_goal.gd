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
	if blueOnGoal and orangeOnGoal:
		point_light.enabled = true
		load_sfx(sfx_win)
		%sfx_player.play()
		var current_scene_file = get_tree().current_scene.scene_file_path
		
		# Extraire correctement le numéro du niveau
		var file_name = current_scene_file.get_file()  # "level_1.tscn"
		var level_number_str = file_name.trim_prefix("level_").trim_suffix(".tscn")  # "1"
		var current_level_number = level_number_str.to_int()
		var next_level_number = current_level_number + 1
		
		next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		
		# VÉRIFIER SI LE NIVEAU SUIVANT EXISTE AVANT DE CONTINUER
		if ResourceLoader.exists(next_level_path):
			
			SaveSystem.save_last_level(next_level_number)
			Engine.time_scale = 0.1
			print("WIN! Prochain niveau : ", next_level_path)
			timer.start()
		else:
			load_music(music_winAll)
			%sfx_music.play()
			SaveSystem.save_last_level(1)
			# Si le niveau suivant n'existe pas, aller directement au niveau 1
			Engine.time_scale = 0.1
			print("Félicitations ! Tu as terminé tous les niveaux !")
			print("Retour au niveau 1")
			next_level_path = first_level_path
			timer.start()
		


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
	

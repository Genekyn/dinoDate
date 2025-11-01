# res://script/platformsSwitch.gd
extends Node

@onready var area_2d: Area2D = $"."
@onready var animatable_neutre_2d: AnimatableBody2D = $AnimatableNeutre2D
@onready var neutral_sprite: Sprite2D = $AnimatableNeutre2D/NeutralSprite
@onready var collision_neutre_2d: CollisionShape2D = $AnimatableNeutre2D/CollisionShape2D
@onready var animatable_blue_2d: AnimatableBody2D = $AnimatableBlue2D
@onready var blue_sprite: Sprite2D = $AnimatableBlue2D/BlueSprite
@onready var collision_blue_2d: CollisionShape2D = $AnimatableBlue2D/CollisionShape2D
@onready var animatable_yellow_2d: AnimatableBody2D = $AnimatableYellow2D
@onready var yellow_sprite: Sprite2D = $AnimatableYellow2D/YellowSprite
@onready var collision_yellow_2d: CollisionShape2D = $AnimatableYellow2D/CollisionShape2D
@onready var point_lightBlue_2d: PointLight2D = $AnimatableBlue2D/PointLight2D
@onready var point_lightYellow_2d: PointLight2D = $AnimatableYellow2D/PointLight2D

@onready var collision_shape_Area2d: CollisionShape2D = $CollisionShape2D
@export var sfx_block : AudioStream
@onready var sfx_player: AudioStreamPlayer2D = %sfx_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.monitoring = true
	area_2d.collision_mask = 6  # Détecte les layers 2 et 4
	
	neutral_sprite.visible = true
	blue_sprite.visible = false
	yellow_sprite.visible = false
	point_lightBlue_2d.enabled = false
	point_lightYellow_2d.enabled = false
	# Activer seulement le neutre au départ
	animatable_neutre_2d.collision_layer = 1
	animatable_blue_2d.collision_layer = 0
	animatable_yellow_2d.collision_layer = 0
	
func _on_body_entered(body: Node2D) -> void:
	print("BodyCollision")
	
	call_deferred("do_claim",body)
	

	
func do_claim(body):
	
	if neutral_sprite.visible == true:
		if body.is_in_group("blueDino"):
			print("BlueDino")
			neutral_sprite.visible = false
			print("ChangeToBlue")
			blue_sprite.visible = true
			point_lightBlue_2d.enabled = true
			load_sfx(sfx_block)
			%sfx_player.play()
			animatable_neutre_2d.set_deferred("collision_layer", 8)
			#animatable_yellow_2d.set_deferred("collision_layer", 0)
			animatable_blue_2d.set_deferred("collision_layer", 2)
			
			
		elif body.is_in_group("orangeDino"):
			print("OrangeDino")
			neutral_sprite.visible = false
			print("ChangeToOrange")
			yellow_sprite.visible = true
			point_lightYellow_2d.enabled = true
			load_sfx(sfx_block)
			%sfx_player.play()
			animatable_neutre_2d.set_deferred("collision_layer", 8)
			#animatable_blue_2d.set_deferred("collision_layer", 0)
			animatable_yellow_2d.set_deferred("collision_layer", 4)
			
			
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load

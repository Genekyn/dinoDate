# res://script/platformsBlink.gd
extends Node

@onready var animatable_blue_2d: AnimatableBody2D = $AnimatableBlue2D
@onready var blue_sprite: Sprite2D = $AnimatableBlue2D/BlueSprite
@onready var collision_blue_2d: CollisionShape2D = $AnimatableBlue2D/CollisionShape2D
@onready var animatable_yellow_2d: AnimatableBody2D = $AnimatableYellow2D
@onready var yellow_sprite: Sprite2D = $AnimatableYellow2D/YellowSprite
@onready var collision_yellow_2d: CollisionShape2D = $AnimatableYellow2D/CollisionShape2D
@onready var point_lightBlue_2d: PointLight2D = $AnimatableBlue2D/PointLight2D
@onready var point_lightYellow_2d: PointLight2D = $AnimatableYellow2D/PointLight2D
@onready var timer: Timer = $Timer
@export var switchPlatform := 1.0
@export var platform_blue: bool = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = switchPlatform
	timer.start()
	point_lightBlue_2d.enabled = false
	point_lightYellow_2d.enabled = false
	# Appliquer immédiatement la configuration initiale
	_apply_platform_state()
func _apply_platform_state():
	if platform_blue:
		blue_sprite.visible = true
		yellow_sprite.visible = false
		point_lightBlue_2d.enabled = true
		point_lightYellow_2d.enabled = false
		animatable_blue_2d.collision_layer = 2
		animatable_yellow_2d.collision_layer = 0
	else:
		yellow_sprite.visible = true
		blue_sprite.visible = false
		point_lightBlue_2d.enabled = false
		point_lightYellow_2d.enabled = true
		animatable_yellow_2d.collision_layer = 4
		animatable_blue_2d.collision_layer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_timer_timeout() -> void:
	print("Time Out") # Replace with function body.
	call_deferred("do_claim")
		
		
func do_claim():
	platform_blue = !platform_blue
	_apply_platform_state()




	

extends CharacterBody2D

const MAX_SPEED = 150.0
const SPEED = 500.0
const DECELERATION = 700.0
const JUMP_VELOCITY = -350.0

@export var sfx_jump : AudioStream
@export var sfx_footstep : AudioStream


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var footstep_frames : Array = [1,4]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump01") and is_on_floor():
		load_sfx(sfx_jump)
		%sfx_player.play()
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jumpUp")
		elif velocity.y > 0: 
			animated_sprite.play("jumpDown")
		

	# Get the input direction and handle the movement/deceleration.
	
	var direction := Input.get_axis("move_left01", "move_right01")
	
	# Flip The sprite
	if direction > 0: 
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	#Play animations
	if is_on_floor():
		
		if direction == 0: 
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	var target = direction * MAX_SPEED
	if direction != 0: 
		target =  direction * MAX_SPEED
	else:
		target = 0
	# Apply the movement 
	if direction:
		velocity.x = move_toward(velocity.x, target, SPEED * delta) 
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	

	move_and_slide()
	
	
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load



	
	


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "idle": return
	if $AnimatedSprite2D.animation == "jumpUp": return
	if $AnimatedSprite2D.animation == "jumpDown": return
	if $AnimatedSprite2D.animation == "jumpNeutral": return
	
	load_sfx(sfx_footstep)
	if $AnimatedSprite2D.frame in footstep_frames: %sfx_player.play()

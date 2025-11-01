extends Area2D

@onready var timer: Timer = $Timer
@export var sfx_death : AudioStream
# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node2D) -> void:
	print("T'ES MORT !")
	load_sfx(sfx_death)
	%sfx_player.play()
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load

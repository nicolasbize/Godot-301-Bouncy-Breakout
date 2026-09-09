class_name Paddle
extends AnimatableBody2D

func _physics_process(delta):
	position.x = clamp(get_global_mouse_position().x, 17, 183)

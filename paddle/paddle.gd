extends AnimatableBody2D

var player_name = "Robin"
var score = 0
var speed = 4.6

func add_points(amount):
	score += amount
	return score

func reset():
	score = 0

func _physics_process(delta):
	position.x = clamp(get_global_mouse_position().x, 17, 183)

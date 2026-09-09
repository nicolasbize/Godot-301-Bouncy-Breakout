class_name World
extends Node2D

var ball_blueprint := preload("res://ball/ball.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var paddle: Paddle = $Paddle
@onready var score_label: Label = $ScoreLabel

var nb_balls_in_play := 0
var current_score := 0

func _ready() -> void:
	create_new_ball()

func _on_ball_detection_area_body_entered(ball: Node2D) -> void:
	ball.queue_free()
	nb_balls_in_play -= 1
	if nb_balls_in_play == 0:
		animation_player.play("lose")

func create_new_ball() -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = paddle
	add_child(new_ball)
	nb_balls_in_play += 1

func _on_level_cleared() -> void:
	animation_player.play("win")

func _on_level_spawn_requested(amount: int, spawn_position: Vector2) -> void:
	for i in amount:
		spawn_ball(spawn_position)

func spawn_ball(spawn_position: Vector2) -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = paddle
	add_child(new_ball)
	nb_balls_in_play += 1
	new_ball.launch(spawn_position)
	
func _on_level_points_scored(amount: int) -> void:
	current_score += amount * nb_balls_in_play
	score_label.text = "%06d" % current_score
